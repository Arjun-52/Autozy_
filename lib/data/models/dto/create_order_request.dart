/// Request body for POST /api/v1/payments/create-order.
///
/// Exactly one of [subscriptionId] / [addonBookingId] is expected by the
/// backend depending on what is being paid for. [amount] is in rupees and
/// [gateway] is fixed to RAZORPAY for this client.
class CreateOrderRequest {
  final String? subscriptionId;
  final String? addonBookingId;
  final num amount;
  final String gateway;

  CreateOrderRequest({
    this.subscriptionId,
    this.addonBookingId,
    required this.amount,
    this.gateway = 'RAZORPAY',
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'amount': amount,
      'gateway': gateway,
    };
    if (subscriptionId != null) map['subscriptionId'] = subscriptionId;
    if (addonBookingId != null) map['addonBookingId'] = addonBookingId;
    return map;
  }
}
