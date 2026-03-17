import '../user_model.dart';

/// Data Transfer Objects for API responses
class LoginResponseDto {
  final User user;
  final String token;

  const LoginResponseDto({required this.user, required this.token});

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) {
    return LoginResponseDto(
      user: User.fromJson(json['user']),
      token: json['token'] ?? '',
    );
  }
}

class RegisterResponseDto {
  final User user;
  final String token;

  const RegisterResponseDto({required this.user, required this.token});

  factory RegisterResponseDto.fromJson(Map<String, dynamic> json) {
    return RegisterResponseDto(
      user: User.fromJson(json['user']),
      token: json['token'] ?? '',
    );
  }
}

class OtpVerifyResponseDto {
  final User user;
  final String token;

  const OtpVerifyResponseDto({required this.user, required this.token});

  factory OtpVerifyResponseDto.fromJson(Map<String, dynamic> json) {
    return OtpVerifyResponseDto(
      user: User.fromJson(json['user']),
      token: json['token'] ?? '',
    );
  }
}
