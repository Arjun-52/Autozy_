import 'app_exceptions.dart';
import 'error_handler.dart';
import '../utils/app_logger.dart';

class RetryHelper {
  /// Execute function with retry logic
  static Future<T> executeWithRetry<T>(
    Future<T> Function() function, {
    int maxRetries = 3,
    bool Function(AppException)? shouldRetry,
  }) async {
    AppException? lastException;

    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        return await function();
      } catch (error) {
        lastException = ErrorHandler.handleException(error);

        // Check if we should retry
        final customShouldRetry = shouldRetry ?? ErrorHandler.isRetryable;
        if (!customShouldRetry(lastException) || attempt == maxRetries) {
          AppLogger.warning('Retry failed after $attempt attempts', tag: 'RetryHelper');
          rethrow;
        }

        // Wait before retry
        final delay = ErrorHandler.getRetryDelay(lastException, attempt);
        AppLogger.debug(
          'Retrying after ${delay}ms (attempt $attempt/$maxRetries)',
          tag: 'RetryHelper',
        );
        await Future.delayed(Duration(milliseconds: delay));
      }
    }

    throw lastException!;
  }

  /// Simple retry for common cases
  static Future<T> retry<T>(Future<T> Function() function) async {
    return executeWithRetry(function);
  }

  /// No retry for critical operations
  static Future<T> executeOnce<T>(Future<T> Function() function) async {
    try {
      return await function();
    } catch (error) {
      throw ErrorHandler.handleException(error);
    }
  }
}
