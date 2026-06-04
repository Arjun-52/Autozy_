import 'user_profile.dart';

class UserProfileResponse {
  final bool success;
  final UserProfile? data;
  final String timestamp;

  UserProfileResponse({
    required this.success,
    this.data,
    required this.timestamp,
  });

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) =>
      UserProfileResponse(
        success: json['success'] ?? false,
        data: json['data'] != null ? UserProfile.fromJson(json['data']) : null,
        timestamp: json['timestamp'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        if (data != null) 'data': data!.toJson(),
        'timestamp': timestamp,
      };
}
