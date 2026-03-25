import '../../core/utils/app_logger.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _apiService;

  AuthService(this._apiService);

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      AppLogger.debug('Attempting login: $email', tag: 'Auth');

      // Mock API call - simulate login
      await Future.delayed(const Duration(seconds: 1));

      // Mock: Accept any email/password for testing
      final mockResponse = {
        'success': true,
        'message': 'Login successful',
        'token': 'mock_jwt_token_12345',
        'user': {
          'id': '1',
          'name': 'Test User',
          'email': email,
          'phone': '+91XXXXXXXXXX',
        },
      };

      AppLogger.info('Login successful (mock)', tag: 'Auth');
      return mockResponse;
    } catch (e, st) {
      AppLogger.error('Login failed', tag: 'Auth', error: e, stackTrace: st);
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
      AppLogger.debug('Registering user: $email', tag: 'Auth');
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
      AppLogger.info('Registration successful', tag: 'Auth');
      return data;
    } catch (e, st) {
      AppLogger.error('Registration failed', tag: 'Auth', error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> sendOtp(String phone) async {
    try {
      AppLogger.debug('Sending OTP to: $phone', tag: 'Auth');

      // Mock API call - simulate successful OTP sending
      await Future.delayed(const Duration(seconds: 1));

      final response = {
        'success': true,
        'message': 'OTP sent successfully',
        'otpId': '123456',
      };

      AppLogger.info('OTP sent successfully (mock)', tag: 'Auth');
      return response;
    } catch (e, st) {
      AppLogger.error('OTP send failed', tag: 'Auth', error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> verifyOtp(String phone, String otp) async {
    try {
      AppLogger.debug('Verifying OTP for: $phone', tag: 'Auth');

      // Mock API call - simulate OTP verification
      await Future.delayed(const Duration(seconds: 1));

      // Mock: Accept any 4-digit OTP for testing
      final isValid = otp.length == 4;

      final response = {
        'success': isValid,
        'message': isValid ? 'OTP verified successfully' : 'Invalid OTP',
        'user': isValid
            ? {
                'id': '1',
                'name': 'Test User',
                'email': 'test@example.com',
                'phone': phone,
              }
            : null,
      };

      AppLogger.info('OTP verification: ${isValid ? 'success' : 'failed'}', tag: 'Auth');
      return response;
    } catch (e, st) {
      AppLogger.error('OTP verification failed', tag: 'Auth', error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      AppLogger.debug('Logging out', tag: 'Auth');
      await _apiService.post('/auth/logout');
      _apiService.clearAuthToken();
      AppLogger.info('Logout successful', tag: 'Auth');
    } catch (e, st) {
      AppLogger.error('Logout failed', tag: 'Auth', error: e, stackTrace: st);
      _apiService.clearAuthToken();
      rethrow;
    }
  }

  Future<Map<String, dynamic>> refreshToken() async {
    try {
      AppLogger.debug('Refreshing token', tag: 'Auth');
      final responseData = await _apiService.post('/auth/refresh-token');
      _apiService.setAuthToken(responseData['token']);
      AppLogger.info('Token refreshed', tag: 'Auth');
      return responseData;
    } catch (e, st) {
      AppLogger.error('Token refresh failed', tag: 'Auth', error: e, stackTrace: st);
      _apiService.clearAuthToken();
      rethrow;
    }
  }

  Future<Map<String, dynamic>> forgotPassword(String email) async {
    try {
      AppLogger.debug('Forgot password request: $email', tag: 'Auth');
      final data = await _apiService.post(
        '/auth/forgot-password',
        data: {'email': email},
      );
      return data;
    } catch (e, st) {
      AppLogger.error('Forgot password failed', tag: 'Auth', error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> resetPassword(
    String token,
    String newPassword,
  ) async {
    try {
      AppLogger.debug('Resetting password', tag: 'Auth');
      final data = await _apiService.post(
        '/auth/reset-password',
        data: {'token': token, 'newPassword': newPassword},
      );
      return data;
    } catch (e, st) {
      AppLogger.error('Password reset failed', tag: 'Auth', error: e, stackTrace: st);
      rethrow;
    }
  }
}
