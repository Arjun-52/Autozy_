import '../plan_model.dart';

class PlanResponse {
  final bool success;
  final List<Plan>? plans;
  final String? timestamp;

  PlanResponse({
    required this.success,
    this.plans,
    this.timestamp,
  });

  factory PlanResponse.fromJson(Map<String, dynamic> json) {
    final list = json['data'] as List?;
    return PlanResponse(
      success: json['success'] as bool? ?? false,
      plans: list != null
          ? list.map((e) => Plan.fromJson(e as Map<String, dynamic>)).toList()
          : null,
      timestamp: json['timestamp'] as String?,
    );
  }
}
