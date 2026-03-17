/// Base exception for all app errors
abstract class AppException implements Exception {
  final String userMessage;
  final String? technicalMessage;
  final String? code;
  final int? statusCode;
  
  const AppException({
    required this.userMessage,
    this.technicalMessage,
    this.code,
    this.statusCode,
  });
  
  @override
  String toString() => userMessage;
}

/// Network-related errors
class NetworkException extends AppException {
  const NetworkException({
    required String userMessage,
    String? technicalMessage,
    String? code,
  }) : super(
    userMessage: userMessage,
    technicalMessage: technicalMessage,
    code: code,
  );
}

/// Server-side errors (4xx, 5xx)
class ServerException extends AppException {
  const ServerException({
    required String userMessage,
    required int statusCode,
    String? technicalMessage,
    String? code,
  }) : super(
    userMessage: userMessage,
    technicalMessage: technicalMessage,
    code: code,
    statusCode: statusCode,
  );
}

/// Validation errors (400)
class ValidationException extends AppException {
  final Map<String, String>? fieldErrors;
  
  const ValidationException({
    required String userMessage,
    this.fieldErrors,
    String? technicalMessage,
    String? code,
  }) : super(
    userMessage: userMessage,
    technicalMessage: technicalMessage,
    code: code,
    statusCode: 400,
  );
}

/// Authentication errors (401, 403)
class AuthException extends AppException {
  const AuthException({
    required String userMessage,
    String? technicalMessage,
    String? code,
    int? statusCode,
  }) : super(
    userMessage: userMessage,
    technicalMessage: technicalMessage,
    code: code,
    statusCode: statusCode,
  );
}

/// Resource not found (404)
class NotFoundException extends AppException {
  const NotFoundException({
    required String userMessage,
    String? technicalMessage,
    String? code,
  }) : super(
    userMessage: userMessage,
    technicalMessage: technicalMessage,
    code: code,
    statusCode: 404,
  );
}

/// Timeout errors
class TimeoutException extends AppException {
  const TimeoutException({
    required String userMessage,
    String? technicalMessage,
    String? code,
  }) : super(
    userMessage: userMessage,
    technicalMessage: technicalMessage,
    code: code,
  );
}

/// Unknown errors
class UnknownException extends AppException {
  const UnknownException({
    required String userMessage,
    String? technicalMessage,
    String? code,
  }) : super(
    userMessage: userMessage,
    technicalMessage: technicalMessage,
    code: code,
  );
}
