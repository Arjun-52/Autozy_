import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'api_interceptor.dart';

/// Enhanced API client with interceptors and retry logic
class ApiClient {
  static const String baseUrl = 'https://api.autozy.com';
  static const Duration defaultTimeout = Duration(seconds: 10);
  static const int maxRetries = 3;
  
  String? _authToken;
  
  /// Configuration for different environments
  static bool isProduction = true;
  static String get baseUrl => isProduction 
      ? 'https://api.autozy.com' 
      : 'https://api-staging.autozy.com';
  
  void setAuthToken(String token) {
    _authToken = token;
    developer.log('Auth token set');
  }
  
  void clearAuthToken() {
    _authToken = null;
    developer.log('Auth token cleared');
  }
  
  Map<String, String> _getHeaders() {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'X-Client-Version': '1.0.0',
      'X-Platform': 'flutter',
    };
    
    if (_authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }
    
    return headers;
  }
  
  /// Enhanced GET with retry logic
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    int? maxRetries,
  }) async {
    final retries = maxRetries ?? ApiClient.maxRetries;
    
    for (int attempt = 1; attempt <= retries; attempt++) {
      try {
        final request = http.Request('GET', '$baseUrl$endpoint');
        
        // Apply interceptor
        final interceptedRequest = await ApiInterceptor.interceptRequest(request);
        
        final uri = Uri.parse(interceptedRequest.url.toString())
            .replace(queryParameters: queryParameters);
        
        final response = await http.get(uri, headers: _getHeaders())
            .timeout(defaultTimeout);
        
        // Apply response interceptor
        final interceptedResponse = await ApiInterceptor.interceptResponse(response, request);
        
        return _handleResponse(interceptedResponse);
      } catch (e) {
        developer.log('GET attempt $attempt failed: $e');
        
        if (attempt == retries) {
          throw _handleError(e);
        }
        
        // Exponential backoff
        await Future.delayed(Duration(milliseconds: 1000 * attempt));
      }
    }
    
    throw Exception('Max retries exceeded');
  }
  
  /// Enhanced POST with retry logic
  Future<Map<String, dynamic>> post(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    int? maxRetries,
  }) async {
    final retries = maxRetries ?? ApiClient.maxRetries;
    
    for (int attempt = 1; attempt <= retries; attempt++) {
      try {
        final request = http.Request('POST', '$baseUrl$endpoint');
        final interceptedRequest = await ApiInterceptor.interceptRequest(request);
        
        final uri = Uri.parse(interceptedRequest.url.toString())
            .replace(queryParameters: queryParameters);
        
        final response = await http.post(
          uri,
          headers: _getHeaders(),
          body: data != null ? json.encode(data) : null,
        ).timeout(defaultTimeout);
        
        final interceptedResponse = await ApiInterceptor.interceptResponse(response, request);
        
        return _handleResponse(interceptedResponse);
      } catch (e) {
        developer.log('POST attempt $attempt failed: $e');
        
        if (attempt == retries) {
          throw _handleError(e);
        }
        
        await Future.delayed(Duration(milliseconds: 1000 * attempt));
      }
    }
    
    throw Exception('Max retries exceeded');
  }
  
  /// PUT method
  Future<Map<String, dynamic>> put(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final request = http.Request('PUT', '$baseUrl$endpoint');
      final interceptedRequest = await ApiInterceptor.interceptRequest(request);
      
      final uri = Uri.parse(interceptedRequest.url.toString())
          .replace(queryParameters: queryParameters);
      
      final response = await http.put(
        uri,
        headers: _getHeaders(),
        body: data != null ? json.encode(data) : null,
      ).timeout(defaultTimeout);
      
      return _handleResponse(
        await ApiInterceptor.interceptResponse(response, request),
      );
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  /// DELETE method
  Future<Map<String, dynamic>> delete(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final request = http.Request('DELETE', '$baseUrl$endpoint');
      final interceptedRequest = await ApiInterceptor.interceptRequest(request);
      
      final uri = Uri.parse(interceptedRequest.url.toString())
          .replace(queryParameters: queryParameters);
      
      final response = await http.delete(
        uri, 
        headers: _getHeaders()
      ).timeout(defaultTimeout);
      
      return _handleResponse(
        await ApiInterceptor.interceptResponse(response, request),
      );
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  /// PATCH method
  Future<Map<String, dynamic>> patch(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final request = http.Request('PATCH', '$baseUrl$endpoint');
      final interceptedRequest = await ApiInterceptor.interceptRequest(request);
      
      final uri = Uri.parse(interceptedRequest.url.toString())
          .replace(queryParameters: queryParameters);
      
      final response = await http.patch(
        uri,
        headers: _getHeaders(),
        body: data != null ? json.encode(data) : null,
      ).timeout(defaultTimeout);
      
      return _handleResponse(
        await ApiInterceptor.interceptResponse(response, request),
      );
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  /// Enhanced response handling with structured errors
  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return {'success': true, 'data': null};
      }
      
      try {
        final data = json.decode(response.body);
        return {'success': true, 'data': data};
      } catch (e) {
        developer.log('JSON parsing error: $e');
        throw Exception('Invalid response format');
      }
    } else {
      return _handleHttpError(response);
    }
  }
  
  /// Structured HTTP error handling
  Map<String, dynamic> _handleHttpError(http.Response response) {
    final statusCode = response.statusCode;
    String message = 'Request failed';
    String errorCode = 'HTTP_ERROR';
    
    try {
      final errorData = json.decode(response.body);
      message = errorData['message'] ?? message;
      errorCode = errorData['code'] ?? 'HTTP_$statusCode';
    } catch (e) {
      message = 'Error $statusCode: ${response.body}';
      errorCode = 'HTTP_$statusCode';
    }
    
    return {
      'success': false,
      'error': {
        'code': errorCode,
        'message': message,
        'statusCode': statusCode,
      }
    };
  }
  
  /// Enhanced error handling
  Exception _handleError(dynamic error) {
    if (error is http.TimeoutException) {
      return Exception(
        'Request timeout. Please check your connection and try again.',
      );
    } else if (error is http.ClientException) {
      return Exception(
        'Network error. Please check your internet connection.',
      );
    } else if (error.toString().contains('SocketException')) {
      return Exception(
        'Unable to connect to server. Please try again later.',
      );
    }
    
    developer.log('Unexpected error: $error');
    return Exception('An unexpected error occurred. Please try again.');
  }
}
