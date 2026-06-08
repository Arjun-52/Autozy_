import 'nearby_areas_response.dart';

class AreaDetailsResponse {
  final bool success;
  final Area? data;
  final String? timestamp;

  AreaDetailsResponse({
    required this.success,
    this.data,
    this.timestamp,
  });

  factory AreaDetailsResponse.fromJson(Map<String, dynamic> json) {
    return AreaDetailsResponse(
      success: json['success'] ?? false,
      data: json['data'] != null ? Area.fromJson(json['data']) : null,
      timestamp: json['timestamp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data?.toJson(),
      'timestamp': timestamp,
    };
  }
}
