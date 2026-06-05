import 'package:flutter/material.dart';
import '../../core/utils/app_logger.dart';
import '../data/models/dto/my_addon_bookings_response.dart';
import '../data/repositories/addon_repository.dart';
import '../data/models/dto/book_addon_request_model.dart';
import '../data/models/dto/book_addon_response_model.dart';

enum AddonBookingStatus { initial, loading, success, empty, error }

class AddonBookingProvider extends ChangeNotifier {
  final AddonRepository _repository;

  AddonBookingProvider(this._repository);

  List<AddonBookingModel> _bookings = [];
  AddonBookingPaginationModel? _meta;
  AddonBookingStatus _status = AddonBookingStatus.initial;
  String? _errorMessage;
  bool _isPageLoading = false;

  // Booking action states
  bool _isBooking = false;
  String? _bookingError;
  BookedAddonDataModel? _lastBookedAddon;

  List<AddonBookingModel> get bookings => _bookings;
  AddonBookingPaginationModel? get meta => _meta;
  AddonBookingStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get isPageLoading => _isPageLoading;

  bool get isBooking => _isBooking;
  String? get bookingError => _bookingError;
  BookedAddonDataModel? get lastBookedAddon => _lastBookedAddon;

  Future<void> fetchBookings({bool isRefresh = false}) async {
    if (_status == AddonBookingStatus.loading || _isPageLoading) return;

    if (isRefresh) {
      AppLogger.info('Refresh triggered for My Add-on Bookings', tag: 'Addons');
      _status = AddonBookingStatus.loading;
      _errorMessage = null;
      notifyListeners();
    } else {
      _status = AddonBookingStatus.loading;
      _errorMessage = null;
      _bookings = [];
      _meta = null;
      notifyListeners();
    }

    try {
      final response = await _repository.getMyAddonBookings(page: 1, limit: 20);

      _bookings = response.data;
      _meta = response.meta;

      if (_bookings.isEmpty) {
        _status = AddonBookingStatus.empty;
      } else {
        _status = AddonBookingStatus.success;
      }
    } catch (e) {
      final errorStr = e.toString().toLowerCase();
      if (errorStr.contains('invalid time value') || errorStr.contains('not found')) {
        _status = AddonBookingStatus.empty;
        _bookings = [];
        _meta = null;
      } else {
        _status = AddonBookingStatus.error;
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      }
    } finally {
      notifyListeners();
    }
  }

  Future<void> loadMore() async {
    if (_isPageLoading || _meta == null) return;

    final nextPage = _meta!.page + 1;
    if (nextPage > _meta!.totalPages) return;

    AppLogger.info('Pagination loaded. Loading page $nextPage of Add-on Bookings', tag: 'Addons');
    _isPageLoading = true;
    notifyListeners();

    try {
      final response = await _repository.getMyAddonBookings(page: nextPage, limit: 20);
      _bookings.addAll(response.data);
      _meta = response.meta;
    } catch (e) {
      AppLogger.error('Failed to load page $nextPage of Add-on Bookings', tag: 'Addons', error: e);
    } finally {
      _isPageLoading = false;
      notifyListeners();
    }
  }

  Future<bool> bookAddon(BookAddonRequestModel request) async {
    _isBooking = true;
    _bookingError = null;
    _lastBookedAddon = null;
    notifyListeners();

    try {
      final response = await _repository.bookAddonService(request);
      if (response.success && response.data != null) {
        _lastBookedAddon = response.data;
        // Fetch fresh bookings so that the new booking is included in the list
        fetchBookings(isRefresh: true);
        return true;
      } else {
        _bookingError = 'Booking failed';
        return false;
      }
    } catch (e) {
      _bookingError = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _isBooking = false;
      notifyListeners();
    }
  }

  void clearBookingState() {
    _bookingError = null;
    _lastBookedAddon = null;
    notifyListeners();
  }
}

