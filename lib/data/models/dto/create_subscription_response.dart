class CreateSubscriptionResponse {
  final bool success;
  final SubscriptionModel? data;
  final String? timestamp;

  CreateSubscriptionResponse({
    required this.success,
    this.data,
    this.timestamp,
  });

  factory CreateSubscriptionResponse.fromJson(Map<String, dynamic> json) {
    return CreateSubscriptionResponse(
      success: json['success'] as bool? ?? false,
      data: json['data'] != null
          ? SubscriptionModel.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      timestamp: json['timestamp'] as String?,
    );
  }
}

class SubscriptionModel {
  final String id;
  final String status;
  final String vehicleId;
  final String planPricingId;

  SubscriptionModel({
    required this.id,
    required this.status,
    required this.vehicleId,
    required this.planPricingId,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      id: json['id'] as String? ?? '',
      status: json['status'] as String? ?? '',
      vehicleId: json['vehicleId'] as String? ?? '',
      planPricingId: json['planPricingId'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'vehicleId': vehicleId,
      'planPricingId': planPricingId,
    };
  }
}
