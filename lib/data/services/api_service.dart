import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/utils/app_logger.dart';

import '../../core/network/api_config.dart';

class ApiService {
  static String get baseUrl => ApiConfig.baseUrl;
  String? _authToken;

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

  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final uri = Uri.parse(
        '$baseUrl$endpoint',
      ).replace(queryParameters: queryParameters);
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

  Future<Map<String, dynamic>> postMultipart(
    String endpoint, {
    required String filePath,
    required String fieldName,
  }) async {
    try {
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
      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> postMultipartMultiple(
    String endpoint, {
    required List<String> filePaths,
    required String fieldName,
  }) async {
    try {
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
      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return {};
      }
      return json.decode(response.body);
    } else {
      final statusCode = response.statusCode;
      print('HTTP ERROR BODY: ${response.body}');
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
