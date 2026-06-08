import '../../core/utils/app_logger.dart';
import '../services/api_service.dart';
import '../models/dto/nearby_areas_response.dart';
import '../models/dto/area_details_response.dart';

class AreaRepository {
  final ApiService _apiService;

  AreaRepository(this._apiService);

  Future<NearbyAreasResponse> getNearbyAreas({
    required double latitude,
    required double longitude,
  }) async {
    try {
      AppLogger.info(
        'Nearby areas requested with Lat: $latitude, Lng: $longitude',
        tag: 'Areas',
      );
      final data = await _apiService.get(
        '/api/v1/areas',
        queryParameters: {
          'lat': latitude.toString(),
          'lng': longitude.toString(),
        },
      );
      final response = NearbyAreasResponse.fromJson(data);
      AppLogger.info(
        'Areas loaded count: ${response.areas?.length ?? 0}',
        tag: 'Areas',
      );
      return response;
    } catch (e, st) {
      AppLogger.error(
        'Failed to fetch nearby areas',
        tag: 'Areas',
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  Future<AreaDetailsResponse> getAreaDetails(String areaId) async {
    try {
      AppLogger.info('Area details request start. Area id received: $areaId', tag: 'Areas');
      final data = await _apiService.get('/api/v1/areas/$areaId');
      AppLogger.info('API response received', tag: 'Areas');
      final response = AreaDetailsResponse.fromJson(data);
      if (response.success && response.data != null) {
        AppLogger.info('Area parsing success: ${response.data!.name}', tag: 'Areas');
        if (response.data!.city != null) {
          AppLogger.info('City parsing success: ${response.data!.city!.name}', tag: 'Areas');
        }
      }
      return response;
    } catch (e, st) {
      AppLogger.error('Failed to fetch area details', tag: 'Areas', error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> joinAreaWaitlist(String areaId) async {
    try {
      AppLogger.info('Waitlist request start. Area ID: $areaId', tag: 'Areas');
      final data = await _apiService.post(
        '/api/v1/areas/waitlist',
        data: {'areaId': areaId},
      );
      AppLogger.info('Waitlist request success', tag: 'Areas');
      return data;
    } catch (e, st) {
      AppLogger.error('Waitlist request failure', tag: 'Areas', error: e, stackTrace: st);
      rethrow;
    }
  }
}
