import '../logout_data.dart';

class LogoutResponse {
  final bool success;
  final LogoutData? data;
  final String? timestamp;

  LogoutResponse({required this.success, this.data, this.timestamp});

  factory LogoutResponse.fromJson(Map<String, dynamic> json) => LogoutResponse(
        success: json['success'] ?? false,
        data: json['data'] != null ? LogoutData.fromJson(json['data']) : null,
        timestamp: json['timestamp'],
      );
}
