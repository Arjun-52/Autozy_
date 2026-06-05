import '../../core/utils/app_logger.dart';
import '../services/api_service.dart';
import '../models/dto/service_history_response.dart';
import '../models/dto/service_calendar_response.dart';

class DailyServiceRepository {
  final ApiService _apiService;

  DailyServiceRepository(this._apiService);

  Future<ServiceCalendarModel> getServiceCalendar({
    required String vehicleId,
  }) async {
    try {
      AppLogger.info('Calendar requested. Vehicle ID requested: $vehicleId', tag: 'DailyService');

      final data = await _apiService.get(
        '/api/v1/daily-service/calendar',
        queryParameters: {
          'vehicleId': vehicleId,
        },
      );

      final response = ServiceCalendarResponse.fromJson(data);
      if (response.data == null) {
        throw Exception("Invalid calendar data received");
      }

      AppLogger.info('Calendar loaded successfully', tag: 'DailyService');
      if (response.data!.days.isEmpty) {
        AppLogger.info('Empty calendar received for vehicle ID: $vehicleId', tag: 'DailyService');
      }

      return response.data!;
    } catch (e, st) {
      AppLogger.error('Errors: Failed to load calendar for vehicle $vehicleId', tag: 'DailyService', error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<PaginatedServiceHistoryModel> getServiceHistory({
    required String vehicleId,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      AppLogger.info('History requested. Vehicle ID requested: $vehicleId, page: $page, limit: $limit', tag: 'DailyService');
      
      final data = await _apiService.get(
        '/api/v1/daily-service/history',
        queryParameters: {
          'vehicleId': vehicleId,
          'page': page.toString(),
          'limit': limit.toString(),
        },
      );

      final response = ServiceHistoryResponse.fromJson(data);
      final meta = response.meta ?? ServiceHistoryMetaModel(total: 0, page: page, limit: limit, totalPages: 0);

      AppLogger.info('History loaded. Total items: ${meta.total}', tag: 'DailyService');
      if (response.data.isEmpty) {
        AppLogger.info('Empty history received for vehicle ID: $vehicleId', tag: 'DailyService');
      }

      return PaginatedServiceHistoryModel(
        data: response.data,
        meta: meta,
      );
    } catch (e, st) {
      AppLogger.error('Errors: Failed to load service history for vehicle $vehicleId', tag: 'DailyService', error: e, stackTrace: st);
      rethrow;
    }
  }
}
