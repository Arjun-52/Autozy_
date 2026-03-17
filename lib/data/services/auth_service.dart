import 'api_service.dart';

class AuthService {
  final ApiService _apiService;

  AuthService(this._apiService);

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final data = await _apiService.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      _apiService.setAuthToken(data['token']);
      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String phone,
    String password,
  ) async {
    try {
      final data = await _apiService.post(
        '/auth/register',
        data: {
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
        },
      );

      _apiService.setAuthToken(data['token']);
      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> sendOtp(String phone) async {
    try {
      final data = await _apiService.post(
        '/auth/send-otp',
        data: {'phone': phone},
      );

      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> verifyOtp(String phone, String otp) async {
    try {
      final data = await _apiService.post(
        '/auth/verify-otp',
        data: {'phone': phone, 'otp': otp},
      );

      _apiService.setAuthToken(data['token']);
      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _apiService.post('/auth/logout');
      _apiService.clearAuthToken();
    } catch (e) {
      _apiService.clearAuthToken();
      rethrow;
    }
  }

  Future<Map<String, dynamic>> refreshToken() async {
    try {
      final responseData = await _apiService.post('/auth/refresh-token');

      _apiService.setAuthToken(responseData['token']);
      return responseData;
    } catch (e) {
      _apiService.clearAuthToken();
      rethrow;
    }
  }

  Future<Map<String, dynamic>> forgotPassword(String email) async {
    try {
      final data = await _apiService.post(
        '/auth/forgot-password',
        data: {'email': email},
      );

      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> resetPassword(
    String token,
    String newPassword,
  ) async {
    try {
      final data = await _apiService.post(
        '/auth/reset-password',
        data: {'token': token, 'newPassword': newPassword},
      );

      return data;
    } catch (e) {
      rethrow;
    }
  }
}
