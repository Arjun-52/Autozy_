import 'api_service.dart';

class AuthService {
  final ApiService _apiService;

  AuthService(this._apiService);

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      print('DEBUG: Attempting login with email: $email');

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

      print('DEBUG: Login successful (mock): $mockResponse');
      return mockResponse;
    } catch (e) {
      print('DEBUG: Login failed: $e');
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
      print('DEBUG: Attempting to send OTP to phone: $phone');

      // Mock API call - simulate successful OTP sending
      await Future.delayed(
        const Duration(seconds: 1),
      ); // Simulate network delay

      final mockResponse = {
        'success': true,
        'message': 'OTP sent successfully',
        'otpId': '123456', // Mock OTP ID
      };

      print('DEBUG: OTP sent successfully (mock): $mockResponse');
      return mockResponse;
    } catch (e) {
      print('DEBUG: OTP send failed: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> verifyOtp(String phone, String otp) async {
    try {
      print('DEBUG: Attempting to verify OTP for phone: $phone, OTP: $otp');

      // Mock API call - simulate OTP verification
      await Future.delayed(const Duration(seconds: 1));

      // Mock: Accept any 4-digit OTP for testing
      final isValid = otp.length == 4;

      final mockResponse = {
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

      print('DEBUG: OTP verification result (mock): $mockResponse');
      return mockResponse;
    } catch (e) {
      print('DEBUG: OTP verification failed: $e');
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
