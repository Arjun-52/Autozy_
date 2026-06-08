import '../../core/utils/app_logger.dart';
import '../services/api_service.dart';
import '../models/dto/create_subscription_request.dart';
import '../models/dto/create_subscription_response.dart';
import '../models/dto/subscription_list_response.dart' as list_dto;
import '../models/dto/subscription_details_response.dart';

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

  Future<list_dto.SubscriptionModel> getSubscriptionDetails(String subscriptionId) async {
    try {
      AppLogger.info('Subscription details requested. SubscriptionId: $subscriptionId', tag: 'Subscriptions');
      final data = await _apiService.get('/api/v1/subscriptions/$subscriptionId');
      final response = SubscriptionDetailsResponse.fromJson(data);
      if (response.success && response.data != null) {
        AppLogger.info('Subscription details loaded successfully. Status: ${response.data!.status}', tag: 'Subscriptions');
        return response.data!;
      } else {
        throw Exception('Server returned success: false or empty subscription details data');
      }
    } catch (e, st) {
      AppLogger.error('API failure: Failed to fetch subscription details', tag: 'Subscriptions', error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<bool> pauseSubscription(String subscriptionId, {required String reason, String? customReason}) async {
    try {
      AppLogger.info('Pause subscription requested. SubscriptionId: $subscriptionId, Reason: $reason', tag: 'Subscriptions');
      final payload = {
        'reason': reason,
        if (customReason != null && customReason.isNotEmpty) 'customReason': customReason,
      };
      final data = await _apiService.post('/api/v1/subscriptions/$subscriptionId/pause', data: payload);
      if (data != null && data['success'] == true) {
        AppLogger.info('Subscription paused successfully in repo.', tag: 'Subscriptions');
        return true;
      }
      return false;
    } catch (e, st) {
      AppLogger.error('API failure: Failed to pause subscription', tag: 'Subscriptions', error: e, stackTrace: st);
      rethrow;
    }
  }
}
