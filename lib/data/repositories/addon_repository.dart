import '../../core/utils/app_logger.dart';
import '../services/api_service.dart';
import '../models/dto/my_addon_bookings_response.dart';
import '../models/dto/book_addon_request_model.dart';
import '../models/dto/book_addon_response_model.dart';
import '../models/dto/addon_service_model.dart';

class AddonRepository {
  final ApiService _apiService;

  AddonRepository(this._apiService);

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
      AppLogger.info('Addon booking succeeded. Booking ID: ${response.data?.id}', tag: 'Addons');

      return response;
    } catch (e, st) {
      AppLogger.error('Errors: Failed to book add-on service', tag: 'Addons', error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<List<AddonServiceModel>> getAddonServices({
    String? cityId,
    String? vehicleSize,
  }) async {
    try {
      AppLogger.info('Requesting list of add-on services for cityId: $cityId, vehicleSize: $vehicleSize', tag: 'Addons');
      final queryParams = <String, dynamic>{};
      if (cityId != null) queryParams['cityId'] = cityId;
      if (vehicleSize != null) queryParams['vehicleSize'] = vehicleSize;

      final data = await _apiService.get(
        '/api/v1/addons/services',
        queryParameters: queryParams,
        sendAuth: false,
      );
      final List<dynamic> list = data['data'] as List<dynamic>? ?? [];
      return list.map((e) => AddonServiceModel.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e, st) {
      AppLogger.error('Failed to fetch add-on services', tag: 'Addons', error: e, stackTrace: st);
      rethrow;
    }
  }
}

