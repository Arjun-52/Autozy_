import '../../core/utils/app_logger.dart';
import '../models/dto/send_otp_response.dart';
import '../models/dto/logout_response.dart';
import '../models/dto/update_profile_request.dart';
import '../models/dto/user_profile_response.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _apiService;

  AuthService(this._apiService);

  // LOGIN
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      AppLogger.debug('Attempting login: $email', tag: 'Auth');
      await Future.delayed(const Duration(seconds: 1));
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

  // REGISTER
  Future<Map<String, dynamic>> register(String name, String email, String phone, String password) async {
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

  // SEND OTP
  Future<SendOtpResponse> sendOtp(String phone) async {
    try {
      AppLogger.info('OTP request initiated', tag: 'Auth');
      final requestBody = {'phone': phone.trim()};
      final responseData = await _apiService.post('/api/v1/auth/send-otp', data: requestBody);
      final response = SendOtpResponse.fromJson(responseData);
      AppLogger.info('Request success', tag: 'Auth');
      AppLogger.info('Success message received: ${response.data?.message}', tag: 'Auth');
      return response;
    } catch (e, st) {
      AppLogger.error('API failures: OTP send failed', tag: 'Auth', error: e, stackTrace: st);
      rethrow;
    }
  }

  // VERIFY OTP
  Future<Map<String, dynamic>> verifyOtp(String phone, String otp) async {
    try {
      AppLogger.debug('Verifying OTP for: $phone', tag: 'Auth');
      final requestBody = {
        'phone': phone,
        'otp': otp,
        'deviceId': 'autozy_flutter_device',
      };
      final responseData = await _apiService.post('/api/v1/auth/verify-otp', data: requestBody);
      final accessToken = responseData['accessToken'] ?? (responseData['data'] != null ? responseData['data']['accessToken'] : null) ?? '';
      final refreshToken = responseData['refreshToken'] ?? (responseData['data'] != null ? responseData['data']['refreshToken'] : null) ?? '';
      if (accessToken.isNotEmpty) {
        _apiService.setAuthToken(accessToken);
      }
      final normalizedResponse = {
        'success': responseData['success'] ?? true,
        'message': responseData['message'] ?? 'OTP verified successfully',
        'token': accessToken,
        'refreshToken': refreshToken,
        'user': responseData['user'] ?? (responseData['data'] != null ? responseData['data']['user'] : null) ?? {
          'id': '1',
          'name': 'Test User',
          'email': 'test@example.com',
          'phone': phone,
        },
      };
      return normalizedResponse;
    } catch (e, st) {
      AppLogger.error('OTP verification failed', tag: 'Auth', error: e, stackTrace: st);
      rethrow;
    }
  }

  // LOGOUT
  Future<LogoutResponse> logout() async {
    try {
      AppLogger.debug('Logout initiated', tag: 'Auth');
      final responseData = await _apiService.post('/api/v1/auth/logout');
      _apiService.clearAuthToken();
      AppLogger.info('Logout success', tag: 'Auth');
      return LogoutResponse.fromJson(responseData);
    } catch (e, st) {
      AppLogger.error('Logout failed', tag: 'Auth', error: e, stackTrace: st);
      _apiService.clearAuthToken();
      rethrow;
    }
  }

  // GET CURRENT USER (legacy)
  Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      AppLogger.debug('Fetching current user', tag: 'Auth');
      final responseData = await _apiService.get('/api/v1/auth/me');
      AppLogger.info('Current user fetched', tag: 'Auth');
      return responseData;
    } catch (e, st) {
      AppLogger.error('Failed to fetch current user', tag: 'Auth', error: e, stackTrace: st);
      rethrow;
    }
  }

  // GET USER PROFILE
  Future<UserProfileResponse> getUserProfile() async {
    try {
      AppLogger.debug('Fetching user profile', tag: 'Auth');
      final responseData = await _apiService.get('/api/v1/users/me');
      AppLogger.info('User profile fetched', tag: 'Auth');
      return UserProfileResponse.fromJson(responseData);
    } catch (e, st) {
      AppLogger.error('Failed to fetch user profile', tag: 'Auth', error: e, stackTrace: st);
      rethrow;
    }
  }

  // UPDATE USER PROFILE
  Future<UserProfileResponse> updateUserProfile(UpdateProfileRequest request) async {
    try {
      AppLogger.debug('Updating user profile', tag: 'Auth');
      final responseData = await _apiService.patch('/api/v1/users/me', data: request.toJson());
      AppLogger.info('User profile update successful', tag: 'Auth');
      return UserProfileResponse.fromJson(responseData);
    } catch (e, st) {
      AppLogger.error('Failed to update user profile', tag: 'Auth', error: e, stackTrace: st);
      rethrow;
    }
  }

  // REFRESH TOKEN
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

  // FORGOT PASSWORD
  Future<Map<String, dynamic>> forgotPassword(String email) async {
    try {
      AppLogger.debug('Forgot password request: $email', tag: 'Auth');
      final data = await _apiService.post('/auth/forgot-password', data: {'email': email});
      return data;
    } catch (e, st) {
      AppLogger.error('Forgot password failed', tag: 'Auth', error: e, stackTrace: st);
      rethrow;
    }
  }

  // RESET PASSWORD
  Future<Map<String, dynamic>> resetPassword(String token, String newPassword) async {
    try {
      AppLogger.debug('Resetting password', tag: 'Auth');
      final data = await _apiService.post('/auth/reset-password', data: {'token': token, 'newPassword': newPassword});
      return data;
    } catch (e, st) {
      AppLogger.error('Password reset failed', tag: 'Auth', error: e, stackTrace: st);
      rethrow;
    }
  }
}
