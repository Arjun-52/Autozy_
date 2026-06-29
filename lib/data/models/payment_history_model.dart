class PaymentHistoryItem {
  final String id;
  final num amount;
  final String currency;
  final String status; // PENDING | COMPLETED | FAILED | REFUNDED
  final String? invoiceNumber;
  final String? invoiceUrl;
  final num? gstAmount;
  final String? subscriptionId;
  final String? addonBookingId;
  final DateTime? createdAt;

  PaymentHistoryItem({
    required this.id,
    required this.amount,
    this.currency = 'INR',
    required this.status,
    this.invoiceNumber,
    this.invoiceUrl,
    this.gstAmount,
    this.subscriptionId,
    this.addonBookingId,
    this.createdAt,
  });

  bool get isPaid => status.toUpperCase() == 'COMPLETED';

  /// A human label for what the payment was for.
  String get title {
    if (invoiceNumber != null && invoiceNumber!.isNotEmpty) return invoiceNumber!;
    if (addonBookingId != null && addonBookingId!.isNotEmpty) return 'Add-on Service';
    if (subscriptionId != null && subscriptionId!.isNotEmpty) return 'Subscription';
    return 'Payment';
  }

  static num _parseNum(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v;
    return num.tryParse(v.toString()) ?? 0;
  }

  factory PaymentHistoryItem.fromJson(Map<String, dynamic> json) {
    final created = json['createdAt'] ?? json['created_at'];
    return PaymentHistoryItem(
      id: (json['id'] ?? '').toString(),
      amount: _parseNum(json['amount']),
      currency: (json['currency'] ?? 'INR').toString(),
      status: (json['status'] ?? '').toString(),
      invoiceNumber: json['invoiceNumber'] ?? json['invoice_number'],
      invoiceUrl: json['invoiceUrl'] ?? json['invoice_url'],
      gstAmount: json['gstAmount'] != null || json['gst_amount'] != null
          ? _parseNum(json['gstAmount'] ?? json['gst_amount'])
          : null,
      subscriptionId: json['subscriptionId'] ?? json['subscription_id'],
      addonBookingId: json['addonBookingId'] ?? json['addon_booking_id'],
      createdAt: created != null ? DateTime.tryParse(created.toString()) : null,
    );
  }
}
