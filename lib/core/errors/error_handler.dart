import 'app_exceptions.dart';
import '../utils/app_logger.dart';

class ErrorHandler {
  static AppException handleException(dynamic error) {
    AppLogger.error(
      'Error occurred: ${error.runtimeType}',
      tag: 'ErrorHandler',
      error: error,
      stackTrace: StackTrace.current,
    );

    // Handle specific error types
    if (error is AppException) {
      return error;
    }

    // Handle network errors
    if (error.toString().contains('timeout')) {
      return const TimeoutException(
        userMessage:
            'Request timed out. Please check your connection and try again.',
        technicalMessage: 'Network timeout occurred',
        code: 'TIMEOUT',
      );
    }

    if (error.toString().contains('no internet') ||
        error.toString().contains('network') ||
        error.toString().contains('SocketException')) {
      return const NetworkException(
        userMessage:
            'No internet connection. Please check your network settings.',
        technicalMessage: 'Network connectivity issue',
        code: 'NO_INTERNET',
      );
    }

    // Handle HTTP status codes
    final statusCodeMatch = RegExp(
      r'Error (\d{3}):',
    ).firstMatch(error.toString());
    if (statusCodeMatch != null) {
      final statusCode = int.parse(statusCodeMatch.group(1)!);

      switch (statusCode) {
        case 400:
          return const ValidationException(
            userMessage:
                'Invalid information provided. Please check your inputs.',
            code: 'VALIDATION_ERROR',
          );
        case 401:
          return const AuthException(
            userMessage: 'Please log in to continue.',
            code: 'UNAUTHORIZED',
            statusCode: 401,
          );
        case 403:
          return const AuthException(
            userMessage: 'You don\'t have permission to perform this action.',
            code: 'FORBIDDEN',
            statusCode: 403,
          );
        case 404:
          return const NotFoundException(
            userMessage: 'The requested resource was not found.',
            code: 'NOT_FOUND',
          );
        case 429:
          return const ServerException(
            userMessage: 'Too many requests. Please try again later.',
            statusCode: 429,
            code: 'RATE_LIMIT',
          );
        case 500:
        case 502:
        case 503:
          return ServerException(
            userMessage:
                'Server is temporarily unavailable. Please try again later.',
            statusCode: statusCode,
            code: 'SERVER_ERROR',
          );
        default:
          return ServerException(
            userMessage: 'Server error occurred. Please try again.',
            statusCode: statusCode,
            code: 'HTTP_ERROR',
          );
      }
    }

    // Fallback for unknown errors
    return UnknownException(
      userMessage: 'Something went wrong. Please try again.',
      technicalMessage: error.toString(),
      code: 'UNKNOWN_ERROR',
    );
  }

  /// Get user-friendly message for UI display
  static String getUserMessage(AppException exception) {
    return exception.userMessage;
  }

  /// Check if error is retryable
  static bool isRetryable(AppException exception) {
    return exception is NetworkException ||
        exception is TimeoutException ||
        (exception is ServerException &&
            (exception.statusCode == 500 ||
                exception.statusCode == 502 ||
                exception.statusCode == 503 ||
                exception.statusCode == 429));
  }

  /// Get retry delay in milliseconds
  static int getRetryDelay(AppException exception, int attemptNumber) {
    // Exponential backoff: 1s, 2s, 4s, 8s, max 30s
    final delay = (1000 * (1 << (attemptNumber - 1))).clamp(1000, 30000);
    return delay;
  }
}
