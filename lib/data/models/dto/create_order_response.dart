/// Parsed result of POST /api/v1/payments/create-order.
///
/// The backend's response shape is not documented in the OpenAPI spec, so this
/// parses defensively: it unwraps the common `{success, data}` envelope and
/// reads the Razorpay order fields under several possible key names.
class CreateOrderResponse {
  /// Razorpay order id (the `order_xxx` value passed to Checkout and /verify).
  final String razorpayOrderId;

  /// Order amount in the smallest currency unit (paise), as returned by the
  /// gateway. May be 0 if the backend omits it — the caller then falls back.
  final int amount;

  /// ISO currency code, defaults to INR.
  final String currency;

  /// Optional Razorpay publishable key returned by the backend. When present it
  /// takes precedence over the bundled [ApiConfig.razorpayKeyId].
  final String? key;

  /// Optional internal payment record id created by the backend.
  final String? paymentId;

  CreateOrderResponse({
    required this.razorpayOrderId,
    required this.amount,
    this.currency = 'INR',
    this.key,
    this.paymentId,
  });

  factory CreateOrderResponse.fromJson(Map<String, dynamic> json) {
    // Unwrap inconsistent envelope: {data: {...}} | {order: {...}} | {...}
    final root = json['data'] ?? json['order'] ?? json;
    final map = root is Map<String, dynamic> ? root : <String, dynamic>{};

    String? firstString(List<String> keys) {
      for (final k in keys) {
        final v = map[k];
        if (v != null && v.toString().isNotEmpty) return v.toString();
      }
      return null;
    }

    int parseAmount() {
      final v = map['amount'] ?? map['amountDue'] ?? map['amount_due'];
      if (v is int) return v;
      if (v is num) return v.toInt();
      if (v is String) return int.tryParse(v) ?? 0;
      return 0;
    }

    return CreateOrderResponse(
      razorpayOrderId: firstString(
            ['razorpayOrderId', 'orderId', 'order_id', 'id'],
          ) ??
          '',
      amount: parseAmount(),
      currency: firstString(['currency']) ?? 'INR',
      key: firstString(['key', 'keyId', 'razorpayKeyId', 'razorpay_key_id']),
      paymentId: firstString(['paymentId', 'payment_id']),
    );
  }
}
