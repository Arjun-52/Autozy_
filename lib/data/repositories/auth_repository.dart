import '../services/auth_service.dart';
import '../models/user_model.dart';
import '../models/dto/auth_dto.dart';
import '../models/dto/send_otp_response.dart';
import '../models/dto/user_profile.dart';
import '../models/dto/user_profile_response.dart';
import '../models/dto/update_profile_request.dart';

class AuthRepository {
  final AuthService _authService;

  AuthRepository(this._authService);

  // LOGIN
  Future<User> login(String email, String password) async {
    try {
      final response = await _authService.login(email, password);
      final dto = LoginResponseDto.fromJson(response);
      return dto.user;
    } catch (e) {
      rethrow;
    }
  }

  // REGISTER
  Future<User> register(String name, String email, String phone, String password) async {
    try {
      final response = await _authService.register(name, email, phone, password);
      final dto = RegisterResponseDto.fromJson(response);
      return dto.user;
    } catch (e) {
      rethrow;
    }
  }

  // SEND OTP
  Future<SendOtpResponse> sendOtp(String phone) async {
    try {
      return await _authService.sendOtp(phone);
    } catch (e) {
      rethrow;
    }
  }

  // VERIFY OTP
  Future<User> verifyOtp(String phone, String otp) async {
    try {
      final response = await _authService.verifyOtp(phone, otp);
      final dto = OtpVerifyResponseDto.fromJson(response);
      return dto.user;
    } catch (e) {
      rethrow;
    }
  }

  // LOGOUT
  Future<void> logout() async {
    try {
      await _authService.logout();
    } catch (e) {
      rethrow;
    }
  }

  // REFRESH TOKEN
  Future<User> refreshToken() async {
    try {
      final response = await _authService.refreshToken();
      return User.fromJson(response['user']);
    } catch (e) {
      rethrow;
    }
  }

  // FORGOT PASSWORD
  Future<void> forgotPassword(String email) async {
    try {
      await _authService.forgotPassword(email);
    } catch (e) {
      rethrow;
    }
  }

  // GET USER PROFILE
  Future<UserProfile> getUserProfile() async {
    try {
      final response = await _authService.getUserProfile();
      return response.data!;
    } catch (e) {
      rethrow;
    }
  }

  // UPDATE USER PROFILE
  Future<UserProfile> updateUserProfile(UpdateProfileRequest request) async {
    try {
      final response = await _authService.updateUserProfile(request);
      return response.data!;
    } catch (e) {
      rethrow;
    }
  }

  // RESET PASSWORD
  Future<void> resetPassword(String token, String newPassword) async {
    try {
      await _authService.resetPassword(token, newPassword);
    } catch (e) {
      rethrow;
    }
  }
}
