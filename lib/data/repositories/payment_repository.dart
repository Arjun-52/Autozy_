import '../../core/utils/app_logger.dart';
import '../services/api_service.dart';
import '../models/dto/create_order_request.dart';
import '../models/dto/create_order_response.dart';
import '../models/dto/verify_payment_request.dart';
import '../models/payment_history_model.dart';

class PaymentRepository {
  final ApiService _apiService;

  PaymentRepository(this._apiService);

  /// Fetches the user's payment history from GET /api/v1/payments/history.
  Future<List<PaymentHistoryItem>> getPaymentHistory({int page = 1, int limit = 50}) async {
    try {
      AppLogger.info('Fetching payment history (page: $page)', tag: 'Payments');
      final data = await _apiService.get(
        '/api/v1/payments/history',
        queryParameters: {'page': page.toString(), 'limit': limit.toString()},
      );
      final node = data['data'] ?? data;
      final List<dynamic> list = node is Map ? (node['items'] ?? node['data'] ?? []) : (node as List? ?? []);
      return list
          .map((e) => PaymentHistoryItem.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e, st) {
      AppLogger.error('Failed to fetch payment history', tag: 'Payments', error: e, stackTrace: st);
      rethrow;
    }
  }

  /// Creates a Razorpay order on the backend for the given subscription/addon.
  Future<CreateOrderResponse> createOrder(CreateOrderRequest request) async {
    try {
      AppLogger.info(
        'Create order requested. subscriptionId: ${request.subscriptionId}, amount: ${request.amount}',
        tag: 'Payments',
      );
      final data = await _apiService.post(
        '/api/v1/payments/create-order',
        data: request.toJson(),
      );

      final response = CreateOrderResponse.fromJson(data);
      if (response.razorpayOrderId.isEmpty) {
        throw Exception('Create order response did not include a Razorpay order id');
      }
      AppLogger.info(
        'Order created. razorpayOrderId: ${response.razorpayOrderId}, amount: ${response.amount}',
        tag: 'Payments',
      );
      return response;
    } catch (e, st) {
      AppLogger.error('API failure: Failed to create payment order', tag: 'Payments', error: e, stackTrace: st);
      rethrow;
    }
  }

  /// Creates a Razorpay order for an existing pending subscription. The backend
  /// computes the GST-inclusive amount server-side from the subscription's
  /// plan pricing, so the client doesn't send (or have to know) the amount.
  /// This is also the resume path for an abandoned/pending subscription.
  Future<CreateOrderResponse> createSubscriptionOrder(String subscriptionId) async {
    try {
      AppLogger.info(
        'Create subscription order requested. subscriptionId: $subscriptionId',
        tag: 'Payments',
      );
      final data = await _apiService.post(
        '/api/v1/payments/create-subscription-order',
        data: {'subscriptionId': subscriptionId, 'gateway': 'RAZORPAY'},
      );

      final response = CreateOrderResponse.fromJson(data);
      if (response.razorpayOrderId.isEmpty) {
        throw Exception('Create order response did not include a Razorpay order id');
      }
      AppLogger.info(
        'Subscription order created. razorpayOrderId: ${response.razorpayOrderId}, amount: ${response.amount}',
        tag: 'Payments',
      );
      return response;
    } catch (e, st) {
      AppLogger.error('API failure: Failed to create subscription order', tag: 'Payments', error: e, stackTrace: st);
      rethrow;
    }
  }

  /// Verifies a completed Razorpay payment with the backend.
  Future<bool> verifyPayment(VerifyPaymentRequest request) async {
    try {
      AppLogger.info('Verify payment requested. orderId: ${request.orderId}, paymentId: ${request.paymentId}', tag: 'Payments');
      final data = await _apiService.post(
        '/api/v1/payments/verify',
        data: request.toJson(),
      );

      final success = data['success'] == true;
      AppLogger.info('Payment verification result: $success', tag: 'Payments');
      return success;
    } catch (e, st) {
      AppLogger.error('API failure: Failed to verify payment', tag: 'Payments', error: e, stackTrace: st);
      rethrow;
    }
  }
}
