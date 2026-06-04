import '../../core/utils/app_logger.dart';
import '../services/api_service.dart';
import '../models/dto/nearby_areas_response.dart';

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
}
