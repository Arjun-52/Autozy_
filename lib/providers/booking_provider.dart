import 'package:flutter/foundation.dart';
import '../data/repositories/booking_repository.dart';
import '../data/models/booking_model.dart';

class BookingProvider extends ChangeNotifier {
  final BookingRepository _bookingRepository;

  List<Booking> _bookings = [];
  List<Booking> _upcomingBookings = [];
  List<Booking> _pastBookings = [];
  bool _isLoading = false;
  String? _error;

  BookingProvider(this._bookingRepository);

  List<Booking> get bookings => _bookings;
  List<Booking> get upcomingBookings => _upcomingBookings;
  List<Booking> get pastBookings => _pastBookings;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchBookings(String userId) async {
    _setLoading(true);
    _clearError();

    try {
      _bookings = await _bookingRepository.getBookings(userId);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchUpcomingBookings(String userId) async {
    _setLoading(true);
    _clearError();

    try {
      _upcomingBookings = await _bookingRepository.getUpcomingBookings(userId);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchPastBookings(String userId) async {
    _setLoading(true);
    _clearError();

    try {
      _pastBookings = await _bookingRepository.getPastBookings(userId);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<Booking> getBookingById(String bookingId) async {
    _clearError();

    try {
      return await _bookingRepository.getBookingById(bookingId);
    } catch (e) {
      _setError(e.toString());
      rethrow;
    }
  }

  Future<void> createBooking(Booking booking) async {
    _setLoading(true);
    _clearError();

    try {
      final newBooking = await _bookingRepository.createBooking(booking);
      _bookings.add(newBooking);

      if (newBooking.bookingDate.isAfter(DateTime.now())) {
        _upcomingBookings.add(newBooking);
      } else {
        _pastBookings.add(newBooking);
      }

      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateBooking(Booking booking) async {
    _setLoading(true);
    _clearError();

    try {
      final updatedBooking = await _bookingRepository.updateBooking(
        booking.id,
        booking,
      );

      final index = _bookings.indexWhere((b) => b.id == booking.id);
      if (index != -1) {
        _bookings[index] = updatedBooking;
      }

      final upcomingIndex = _upcomingBookings.indexWhere(
        (b) => b.id == booking.id,
      );
      if (upcomingIndex != -1) {
        _upcomingBookings[upcomingIndex] = updatedBooking;
      }

      final pastIndex = _pastBookings.indexWhere((b) => b.id == booking.id);
      if (pastIndex != -1) {
        _pastBookings[pastIndex] = updatedBooking;
      }

      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> cancelBooking(String bookingId) async {
    _setLoading(true);
    _clearError();

    try {
      await _bookingRepository.cancelBooking(bookingId);

      final booking = _bookings.firstWhere((b) => b.id == bookingId);
      final updatedBooking = booking.copyWith(status: 'cancelled');

      final index = _bookings.indexWhere((b) => b.id == bookingId);
      if (index != -1) {
        _bookings[index] = updatedBooking;
      }

      _upcomingBookings.removeWhere((b) => b.id == bookingId);
      _pastBookings.removeWhere((b) => b.id == bookingId);

      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> rescheduleBooking(String bookingId, DateTime newDate) async {
    _setLoading(true);
    _clearError();

    try {
      await _bookingRepository.rescheduleBooking(bookingId, newDate);

      final booking = _bookings.firstWhere((b) => b.id == bookingId);
      final updatedBooking = booking.copyWith(bookingDate: newDate);

      final index = _bookings.indexWhere((b) => b.id == bookingId);
      if (index != -1) {
        _bookings[index] = updatedBooking;
      }

      _upcomingBookings.removeWhere((b) => b.id == bookingId);
      _pastBookings.removeWhere((b) => b.id == bookingId);

      if (newDate.isAfter(DateTime.now())) {
        _upcomingBookings.add(updatedBooking);
      } else {
        _pastBookings.add(updatedBooking);
      }

      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<List<Booking>> getBookingsByStatus(
    String userId,
    String status,
  ) async {
    _clearError();

    try {
      return await _bookingRepository.getBookingsByStatus(userId, status);
    } catch (e) {
      _setError(e.toString());
      rethrow;
    }
  }

  void clearBookings() {
    _bookings.clear();
    _upcomingBookings.clear();
    _pastBookings.clear();
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }
}
