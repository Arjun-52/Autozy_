import '../services/api_service.dart';
import 'package:autozy/data/models/booking_model.dart';

class BookingRepository {
  final ApiService _apiService;

  BookingRepository(this._apiService);

  Future<List<Booking>> getBookings(String userId) async {
    try {
      final data = await _apiService.get(
        '/bookings',
        queryParameters: {'userId': userId},
      );

      final List<dynamic> bookings = data['bookings'];
      return bookings.map((booking) => Booking.fromJson(booking)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Booking> getBookingById(String bookingId) async {
    try {
      final data = await _apiService.get('/bookings/$bookingId');
      return Booking.fromJson(data['booking']);
    } catch (e) {
      rethrow;
    }
  }

  Future<Booking> createBooking(Booking booking) async {
    try {
      final data = await _apiService.post('/bookings', data: booking.toJson());
      return Booking.fromJson(data['booking']);
    } catch (e) {
      rethrow;
    }
  }

  Future<Booking> updateBooking(String bookingId, Booking booking) async {
    try {
      final data = await _apiService.put(
        '/bookings/$bookingId',
        data: booking.toJson(),
      );
      return Booking.fromJson(data['booking']);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> cancelBooking(String bookingId) async {
    try {
      await _apiService.delete('/bookings/$bookingId');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> rescheduleBooking(String bookingId, DateTime newDate) async {
    try {
      await _apiService.patch(
        '/bookings/$bookingId/reschedule',
        data: {'newDate': newDate.toIso8601String()},
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Booking>> getBookingsByStatus(
    String userId,
    String status,
  ) async {
    try {
      final data = await _apiService.get(
        '/bookings',
        queryParameters: {'userId': userId, 'status': status},
      );

      final List<dynamic> bookings = data['bookings'];
      return bookings.map((booking) => Booking.fromJson(booking)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Booking>> getUpcomingBookings(String userId) async {
    try {
      final data = await _apiService.get(
        '/bookings/upcoming',
        queryParameters: {'userId': userId},
      );

      final List<dynamic> bookings = data['bookings'];
      return bookings.map((booking) => Booking.fromJson(booking)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Booking>> getPastBookings(String userId) async {
    try {
      final data = await _apiService.get(
        '/bookings/past',
        queryParameters: {'userId': userId},
      );

      final List<dynamic> bookings = data['bookings'];
      return bookings.map((booking) => Booking.fromJson(booking)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
