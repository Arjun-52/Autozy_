import '../../core/utils/app_logger.dart';
import '../services/api_service.dart';
import '../models/dto/create_subscription_request.dart';
import '../models/dto/create_subscription_response.dart';
import '../models/dto/subscription_list_response.dart' as list_dto;

class SubscriptionRepository {
  final ApiService _apiService;

  SubscriptionRepository(this._apiService);

  Future<SubscriptionModel> createSubscription(CreateSubscriptionRequest request) async {
    try {
      AppLogger.info('Subscription creation requested for Plan Pricing ID: ${request.planPricingId}', tag: 'Subscriptions');
      final data = await _apiService.post(
        '/api/v1/subscriptions',
        data: request.toJson(),
      );

      final response = CreateSubscriptionResponse.fromJson(data);
      if (response.success && response.data != null) {
        AppLogger.info('Subscription created successfully. ID: ${response.data!.id}, Status: ${response.data!.status}', tag: 'Subscriptions');
        return response.data!;
      } else {
        throw Exception('Server returned success: false or empty subscription data');
      }
    } catch (e, st) {
      AppLogger.error('API failure: Failed to create subscription', tag: 'Subscriptions', error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<List<list_dto.SubscriptionModel>> getSubscriptions({int page = 1, int limit = 20}) async {
    try {
      AppLogger.info('Subscriptions requested with page: $page, limit: $limit', tag: 'Subscriptions');
      final data = await _apiService.get(
        '/api/v1/subscriptions',
        queryParameters: {'page': page.toString(), 'limit': limit.toString()},
      );

      final response = list_dto.SubscriptionResponse.fromJson(data);
      final list = response.data ?? [];
      AppLogger.info('Subscriptions loaded count: ${list.length}', tag: 'Subscriptions');
      return list;
    } catch (e, st) {
      AppLogger.error('API failure: Failed to fetch subscriptions list', tag: 'Subscriptions', error: e, stackTrace: st);
      rethrow;
    }
  }
}
