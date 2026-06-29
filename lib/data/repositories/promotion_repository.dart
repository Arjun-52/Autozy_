import '../../core/utils/app_logger.dart';
import '../services/api_service.dart';
import '../models/promotion_model.dart';

class PromotionRepository {
  final ApiService _apiService;

  PromotionRepository(this._apiService);

  static const String _basePath = '/api/v1/promotions';

  /// Fetches active promotions from GET /api/v1/promotions/active.
  Future<List<PromotionModel>> getActivePromotions() async {
    try {
      AppLogger.info('Fetching active promotions', tag: 'Promotions');
      final data = await _apiService.get('$_basePath/active');
      final List<dynamic> list = data['data'] ?? data['promotions'] ?? [];
      return list
          .map((e) => PromotionModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e, st) {
      AppLogger.error('Failed to fetch promotions', tag: 'Promotions', error: e, stackTrace: st);
      rethrow;
    }
  }
}
