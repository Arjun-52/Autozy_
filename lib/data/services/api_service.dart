import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/utils/app_logger.dart';

import '../../core/network/api_config.dart';

class ApiService {
  static String get baseUrl => ApiConfig.baseUrl;
  String? _authToken;
  String? _refreshToken;
  void Function()? onSessionExpired;

  /// Invoked after a successful silent token refresh so callers can persist the
  /// rotated tokens (e.g. to [TokenStorage]). Without this the new tokens live
  /// only in memory and are lost on the next app restart.
  void Function(String accessToken, String refreshToken)? onTokensRefreshed;

  String? get refreshToken => _refreshToken;

  bool get hasToken => _authToken != null && _authToken!.isNotEmpty;

  void setAuthToken(String token) {
    _authToken = token;
    AppLogger.debug('Auth token set', tag: 'ApiService');
  }

  void clearAuthToken() {
    _authToken = null;
    AppLogger.debug('Auth token cleared', tag: 'ApiService');
  }

  void setRefreshToken(String token) {
    _refreshToken = token;
    AppLogger.debug('Refresh token set', tag: 'ApiService');
  }

  void clearRefreshToken() {
    _refreshToken = null;
    AppLogger.debug('Refresh token cleared', tag: 'ApiService');
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

  Future<void> _handleSessionFailure() async {
    clearAuthToken();
    clearRefreshToken();
    if (onSessionExpired != null) {
      onSessionExpired!();
    }
  }

  Future<Map<String, dynamic>> _executeRequestWithRetry(
    String endpoint,
    Future<http.Response> Function() makeRequest,
  ) async {
    try {
      var response = await makeRequest();
      
      if (response.statusCode == 401) {
        if (endpoint == '/api/v1/auth/refresh') {
          throw Exception('Unauthorized');
        }
        
        final storedRefreshToken = _refreshToken;
        if (storedRefreshToken == null || storedRefreshToken.isEmpty) {
          AppLogger.error('No refresh token available. Logging out...', tag: 'ApiService');
          await _handleSessionFailure();
          throw Exception('Session expired');
        }
        
        AppLogger.warning('Unauthorized request (401), attempting token refresh...', tag: 'ApiService');
        try {
          final refreshUri = Uri.parse('$baseUrl/api/v1/auth/refresh');
          final refreshResponse = await http.post(
            refreshUri,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: json.encode({'refreshToken': storedRefreshToken}),
          ).timeout(const Duration(seconds: 10));
          
          if (refreshResponse.statusCode == 401) {
            throw Exception('Refresh token is invalid or expired');
          }
          
          final refreshData = _handleResponse(refreshResponse);
          final success = refreshData['success'] == true;
          final dataObj = refreshData['data'] as Map<String, dynamic>?;
          final newAccessToken = dataObj?['accessToken'] as String?;
          final newRefreshToken = dataObj?['refreshToken'] as String?;
          
          if (success && newAccessToken != null && newRefreshToken != null) {
            setAuthToken(newAccessToken);
            setRefreshToken(newRefreshToken);
            onTokensRefreshed?.call(newAccessToken, newRefreshToken);

            AppLogger.info('Token refresh successful. Retrying original request...', tag: 'ApiService');
            response = await makeRequest();
          } else {
            throw Exception('Token refresh response validation failed');
          }
        } catch (refreshError) {
          AppLogger.error('Token refresh failed: $refreshError', tag: 'ApiService');
          await _handleSessionFailure();
          rethrow;
        }
      }
      
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final uri = Uri.parse(
      '$baseUrl$endpoint',
    ).replace(queryParameters: queryParameters);
    _logRequest('GET', uri);
    return _executeRequestWithRetry(endpoint, () async {
      return await http.get(uri, headers: _getHeaders()).timeout(const Duration(seconds: 10));
    });
  }

  Future<Map<String, dynamic>> post(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    final uri = Uri.parse(
      '$baseUrl$endpoint',
    ).replace(queryParameters: queryParameters);
    _logRequest('POST', uri, data: data);
    return _executeRequestWithRetry(endpoint, () async {
      return await http.post(
        uri,
        headers: _getHeaders(),
        body: data != null ? json.encode(data) : null,
      ).timeout(const Duration(seconds: 10));
    });
  }

  Future<Map<String, dynamic>> put(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    final uri = Uri.parse(
      '$baseUrl$endpoint',
    ).replace(queryParameters: queryParameters);
    _logRequest('PUT', uri, data: data);
    return _executeRequestWithRetry(endpoint, () async {
      return await http.put(
        uri,
        headers: _getHeaders(),
        body: data != null ? json.encode(data) : null,
      ).timeout(const Duration(seconds: 10));
    });
  }

  Future<Map<String, dynamic>> delete(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final uri = Uri.parse(
      '$baseUrl$endpoint',
    ).replace(queryParameters: queryParameters);
    _logRequest('DELETE', uri);
    return _executeRequestWithRetry(endpoint, () async {
      return await http.delete(uri, headers: _getHeaders()).timeout(const Duration(seconds: 10));
    });
  }

  Future<Map<String, dynamic>> patch(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    final uri = Uri.parse(
      '$baseUrl$endpoint',
    ).replace(queryParameters: queryParameters);
    _logRequest('PATCH', uri, data: data);
    return _executeRequestWithRetry(endpoint, () async {
      return await http.patch(
        uri,
        headers: _getHeaders(),
        body: data != null ? json.encode(data) : null,
      ).timeout(const Duration(seconds: 10));
    });
  }

  Future<Map<String, dynamic>> postMultipart(
    String endpoint, {
    required String filePath,
    required String fieldName,
  }) async {
    return _executeRequestWithRetry(endpoint, () async {
      final uri = Uri.parse('$baseUrl$endpoint');
      final request = http.MultipartRequest('POST', uri);

      final headers = _getHeaders();
      headers.remove('Content-Type');
      request.headers.addAll(headers);

      final multipartFile = await http.MultipartFile.fromPath(
        fieldName,
        filePath,
      );
      request.files.add(multipartFile);

      final streamedResponse = await request.send().timeout(const Duration(seconds: 30));
      return await http.Response.fromStream(streamedResponse);
    });
  }

  Future<Map<String, dynamic>> postMultipartMultiple(
    String endpoint, {
    required List<String> filePaths,
    required String fieldName,
  }) async {
    return _executeRequestWithRetry(endpoint, () async {
      final uri = Uri.parse('$baseUrl$endpoint');
      final request = http.MultipartRequest('POST', uri);

      final headers = _getHeaders();
      headers.remove('Content-Type');
      request.headers.addAll(headers);

      for (final path in filePaths) {
        final multipartFile = await http.MultipartFile.fromPath(
          fieldName,
          path,
        );
        request.files.add(multipartFile);
      }

      final streamedResponse = await request.send().timeout(const Duration(seconds: 45));
      return await http.Response.fromStream(streamedResponse);
    });
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
