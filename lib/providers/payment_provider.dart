import 'package:flutter/foundation.dart';
import '../data/repositories/payment_repository.dart';
import '../data/models/dto/create_order_request.dart';
import '../data/models/dto/create_order_response.dart';
import '../data/models/dto/verify_payment_request.dart';
import '../data/models/payment_history_model.dart';

/// Owns the network state for the Razorpay payment flow: creating the order on
/// the backend and verifying the payment afterwards. The Razorpay SDK instance
/// itself lives in [PaymentScreen] because it needs widget lifecycle hooks.
class PaymentProvider extends ChangeNotifier {
  final PaymentRepository _paymentRepository;

  PaymentProvider(this._paymentRepository);

  bool _isCreatingOrder = false;
  bool _isVerifying = false;
  String? _error;
  CreateOrderResponse? _lastOrder;

  bool get isCreatingOrder => _isCreatingOrder;
  bool get isVerifying => _isVerifying;
  bool get isBusy => _isCreatingOrder || _isVerifying;
  String? get error => _error;
  CreateOrderResponse? get lastOrder => _lastOrder;

  // Payment history (invoices) state
  List<PaymentHistoryItem> _history = [];
  bool _isHistoryLoading = false;
  String? _historyError;

  List<PaymentHistoryItem> get history => _history;
  bool get isHistoryLoading => _isHistoryLoading;
  String? get historyError => _historyError;

  /// Total of all completed payments.
  num get totalPaid =>
      _history.where((p) => p.isPaid).fold<num>(0, (sum, p) => sum + p.amount);

  Future<void> fetchHistory() async {
    _isHistoryLoading = true;
    _historyError = null;
    notifyListeners();
    try {
      _history = await _paymentRepository.getPaymentHistory();
    } catch (e) {
      _historyError = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isHistoryLoading = false;
      notifyListeners();
    }
  }

  Future<CreateOrderResponse?> createOrder({
    required String subscriptionId,
    required num amount,
  }) async {
    _isCreatingOrder = true;
    _error = null;
    _lastOrder = null;
    notifyListeners();

    try {
      final request = CreateOrderRequest(
        subscriptionId: subscriptionId,
        amount: amount,
      );
      final order = await _paymentRepository.createOrder(request);
      _lastOrder = order;
      return order;
    } catch (e) {
      _error = e.toString();
      return null;
    } finally {
      _isCreatingOrder = false;
      notifyListeners();
    }
  }

  /// Creates a Razorpay order for [subscriptionId]. Prefers the server-authoritative
  /// `create-subscription-order` endpoint (backend computes the GST-inclusive amount).
  /// If that endpoint isn't deployed yet (404), falls back to `create-order` with the
  /// client-computed GST-inclusive [amount], so payments work against either backend.
  Future<CreateOrderResponse?> createOrderForSubscription({
    required String subscriptionId,
    required num amount,
  }) async {
    final order = await createSubscriptionOrder(subscriptionId: subscriptionId);
    if (order != null) return order;

    // Only fall back when the endpoint is genuinely missing — not for real errors
    // (declined card, invalid subscription, etc.), which must surface as-is.
    final err = _error ?? '';
    final endpointMissing = err.contains('Cannot POST') || err.contains('404');
    if (!endpointMissing) return null;

    return createOrder(subscriptionId: subscriptionId, amount: amount);
  }

  /// Creates an order for an existing pending subscription. The backend derives
  /// the (GST-inclusive) amount from the subscription itself, so none is passed.
  Future<CreateOrderResponse?> createSubscriptionOrder({
    required String subscriptionId,
  }) async {
    _isCreatingOrder = true;
    _error = null;
    _lastOrder = null;
    notifyListeners();

    try {
      final order = await _paymentRepository.createSubscriptionOrder(subscriptionId);
      _lastOrder = order;
      return order;
    } catch (e) {
      _error = e.toString();
      return null;
    } finally {
      _isCreatingOrder = false;
      notifyListeners();
    }
  }

  Future<bool> verifyPayment({
    required String orderId,
    required String paymentId,
    required String signature,
  }) async {
    _isVerifying = true;
    _error = null;
    notifyListeners();

    try {
      final request = VerifyPaymentRequest(
        orderId: orderId,
        paymentId: paymentId,
        signature: signature,
      );
      return await _paymentRepository.verifyPayment(request);
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isVerifying = false;
      notifyListeners();
    }
  }

  void resetState() {
    _isCreatingOrder = false;
    _isVerifying = false;
    _error = null;
    _lastOrder = null;
    notifyListeners();
  }
}
