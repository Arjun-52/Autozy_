/// Request body for POST /api/v1/payments/verify.
///
/// [orderId] is the Razorpay order id, [paymentId] and [signature] come from the
/// Razorpay Checkout success callback (`PaymentSuccessResponse`).
class VerifyPaymentRequest {
  final String orderId;
  final String paymentId;
  final String signature;

  VerifyPaymentRequest({
    required this.orderId,
    required this.paymentId,
    required this.signature,
  });

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'paymentId': paymentId,
      'signature': signature,
    };
  }
}
