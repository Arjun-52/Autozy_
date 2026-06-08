import 'subscription_list_response.dart';

class SubscriptionDetailsResponse {
  final bool success;
  final SubscriptionModel? data;
  final String? timestamp;

  SubscriptionDetailsResponse({
    required this.success,
    this.data,
    this.timestamp,
  });

  factory SubscriptionDetailsResponse.fromJson(Map<String, dynamic> json) {
    return SubscriptionDetailsResponse(
      success: json['success'] as bool? ?? false,
      data: json['data'] != null
          ? SubscriptionModel.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      timestamp: json['timestamp'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'data': data?.id != null ? data! : null,
        'timestamp': timestamp,
      };
}
