import '../../core/utils/app_logger.dart';
import '../services/api_service.dart';
import '../models/dto/my_addon_bookings_response.dart';
import '../models/dto/book_addon_request_model.dart';
import '../models/dto/book_addon_response_model.dart';
import '../models/dto/addon_slots_response_model.dart';

class AddonRepository {
  final ApiService _apiService;

  AddonRepository(this._apiService);

  Future<AddonSlotsResponseModel> getAddonServiceSlots({
    required String addonServiceId,
    required String cityId,
    required String date,
  }) async {
    try {
      AppLogger.info('Fetching addon slots. ServiceId: $addonServiceId, CityId: $cityId, Date: $date', tag: 'Addons');

      final data = await _apiService.get(
        '/api/v1/addons/services/$addonServiceId/slots',
        queryParameters: {
          'cityId': cityId,
          'date': date,
        },
      );

      final response = AddonSlotsResponseModel.fromJson(data);
      return response;
    } catch (e, st) {
      AppLogger.error('Errors: Failed to fetch add-on slots', tag: 'Addons', error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<MyAddonBookingsResponse> getMyAddonBookings({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      AppLogger.info('My add-on bookings requested. Page requested: $page, limit: $limit', tag: 'Addons');

      final data = await _apiService.get(
        '/api/v1/addons/my-bookings',
        queryParameters: {
          'page': page.toString(),
          'limit': limit.toString(),
        },
      );

      final response = MyAddonBookingsResponse.fromJson(data);
      final totalBookings = response.data.length;
      AppLogger.info('Bookings loaded. Count on this page: $totalBookings', tag: 'Addons');

      if (response.meta != null) {
        AppLogger.info('Pagination loaded. Total: ${response.meta!.total}, TotalPages: ${response.meta!.totalPages}', tag: 'Addons');
      }

      return response;
    } catch (e, st) {
      AppLogger.error('Errors: Failed to load add-on bookings', tag: 'Addons', error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<BookAddonResponseModel> bookAddonService(BookAddonRequestModel request) async {
    try {
      AppLogger.info('Addon booking requested. ServiceId: ${request.addonServiceId}, VehicleId: ${request.vehicleId}', tag: 'Addons');

      final data = await _apiService.post(
        '/api/v1/addons/book',
        data: request.toJson(),
      );

      final response = BookAddonResponseModel.fromJson(data);
      AppLogger.info('Addon booking succeeded. Booking ID: ${response.id}', tag: 'Addons');

      return response;
    } catch (e, st) {
      AppLogger.error('Errors: Failed to book add-on service', tag: 'Addons', error: e, stackTrace: st);
      rethrow;
    }
  }
}

