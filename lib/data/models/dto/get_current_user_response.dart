import 'auth_user.dart';

class GetCurrentUserResponse {
  final bool success;
  final AuthUser? data;
  final String? timestamp;

  GetCurrentUserResponse({required this.success, this.data, this.timestamp});

  factory GetCurrentUserResponse.fromJson(Map<String, dynamic> json) =>
      GetCurrentUserResponse(
        success: json['success'] ?? false,
        data: json['data'] != null ? AuthUser.fromJson(json['data']) : null,
        timestamp: json['timestamp'],
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'data': data?.toJson(), 
        'timestamp': timestamp,
      };
}