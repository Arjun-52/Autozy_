import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/utils/app_logger.dart';

class ApiService {
  static const String apiBaseUrl = 'https://autozybackend.gyaanplant.co.in';
  static const String baseUrl = apiBaseUrl;
  String? _authToken;

  bool get hasToken => _authToken != null && _authToken!.isNotEmpty;

  void setAuthToken(String token) {
    _authToken = token;
    AppLogger.debug('Auth token set', tag: 'ApiService');
  }

  void clearAuthToken() {
    _authToken = null;
    AppLogger.debug('Auth token cleared', tag: 'ApiService');
  }

  Map<String, String> _getHeaders() {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (_authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }

    return headers;
  }

  static const String _tag = 'API';

  /// Logs an outgoing request. Body is only logged for write methods.
  void _logRequest(String method, Uri uri, {dynamic data}) {
    AppLogger.info('→ $method ${uri.toString()}', tag: _tag);
    if (data != null) {
      AppLogger.debug('  request body: ${json.encode(data)}', tag: _tag);
    }
  }

  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final uri = Uri.parse(
        '$baseUrl$endpoint',
      ).replace(queryParameters: queryParameters);
      _logRequest('GET', uri);
      final response = await http
          .get(uri, headers: _getHeaders())
          .timeout(const Duration(seconds: 10));

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> post(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final uri = Uri.parse(
        '$baseUrl$endpoint',
      ).replace(queryParameters: queryParameters);
      _logRequest('POST', uri, data: data);
      final response = await http
          .post(
            uri,
            headers: _getHeaders(),
            body: data != null ? json.encode(data) : null,
          )
          .timeout(const Duration(seconds: 10));

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> put(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final uri = Uri.parse(
        '$baseUrl$endpoint',
      ).replace(queryParameters: queryParameters);
      _logRequest('PUT', uri, data: data);
      final response = await http
          .put(
            uri,
            headers: _getHeaders(),
            body: data != null ? json.encode(data) : null,
          )
          .timeout(const Duration(seconds: 10));

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> delete(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final uri = Uri.parse(
        '$baseUrl$endpoint',
      ).replace(queryParameters: queryParameters);
      _logRequest('DELETE', uri);
      final response = await http
          .delete(uri, headers: _getHeaders())
          .timeout(const Duration(seconds: 10));

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> patch(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final uri = Uri.parse(
        '$baseUrl$endpoint',
      ).replace(queryParameters: queryParameters);

      _logRequest('PATCH', uri, data: data);
      final response = await http
          .patch(
            uri,
            headers: _getHeaders(),
            body: data != null ? json.encode(data) : null,
          )
          .timeout(const Duration(seconds: 10));

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    final method = response.request?.method ?? '?';
    final url = response.request?.url.toString() ?? '?';

    if (response.statusCode >= 200 && response.statusCode < 300) {
      AppLogger.info(
        '← ${response.statusCode} $method $url',
        tag: _tag,
      );
      AppLogger.debug('  response body: ${response.body}', tag: _tag);
      if (response.body.isEmpty) {
        return {};
      }
      return json.decode(response.body);
    } else {
      final statusCode = response.statusCode;
      AppLogger.error(
        '← $statusCode $method $url — ${response.body}',
        tag: _tag,
      );
      String message = 'Something went wrong';

      try {
        final errorData = json.decode(response.body);
        if (errorData['errors'] is List && (errorData['errors'] as List).isNotEmpty) {
          message = (errorData['errors'] as List).join(', ');
        } else {
          message = errorData['message'] ?? message;
        }
      } catch (e) {
        message = 'Error $statusCode: ${response.body}';
      }

      throw Exception(message);
    }
  }

  Exception _handleError(dynamic error) {
    AppLogger.error('Request failed', tag: _tag, error: error);
    if (error is Exception) {
      if (error.toString().contains('timeout')) {
        return Exception(
          'Connection timeout. Please check your internet connection.',
        );
      } else if (error.toString().contains('no internet') ||
          error.toString().contains('network')) {
        return Exception('No internet connection');
      } else if (error.toString().contains('SocketException')) {
        return Exception(
          'Unable to connect to server. Please check your internet connection.',
        );
      }
      return error;
    }
    return Exception('An unexpected error occurred');
  }
}
