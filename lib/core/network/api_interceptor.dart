import 'package:http/http.dart' as http;
import '../utils/app_logger.dart';

/// API interceptor for logging, auth, and error handling
class ApiInterceptor {
  /// Intercept request for logging
  static Future<http.BaseRequest> interceptRequest(
    http.BaseRequest request,
  ) async {
    AppLogger.debug('→ ${request.method} ${request.url}', tag: 'ApiInterceptor');

    // Add request ID for tracking
    request.headers['X-Request-ID'] = _generateRequestId();
    request.headers['X-Client-Version'] = '1.0.0';

    return request;
  }

  /// Intercept response for logging and error handling
  static Future<http.Response> interceptResponse(
    http.Response response,
    http.BaseRequest request,
  ) async {
    final status = response.statusCode;
    if (status >= 400) {
      AppLogger.error(
        '← $status ${request.url}',
        tag: 'ApiInterceptor',
        error: response.body,
      );
    } else {
      AppLogger.debug('← $status ${request.url}', tag: 'ApiInterceptor');
    }

    return response;
  }

  /// Generate unique request ID
  static String _generateRequestId() {
    return '${DateTime.now().millisecondsSinceEpoch}-${_randomString(8)}';
  }

  static String _randomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = DateTime.now().millisecondsSinceEpoch;
    String result = '';
    for (int i = 0; i < length; i++) {
      result += chars[(random + i) % chars.length];
    }
    return result;
  }
}
