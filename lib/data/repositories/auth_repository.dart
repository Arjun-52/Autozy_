import '../services/auth_service.dart';
import '../models/user_model.dart';

class AuthRepository {
  final AuthService _authService;

  AuthRepository(this._authService);

  Future<User> login(String email, String password) async {
    try {
      final response = await _authService.login(email, password);
      return User.fromJson(response['user']);
    } catch (e) {
      throw e;
    }
  }

  Future<User> register(String name, String email, String phone, String password) async {
    try {
      final response = await _authService.register(name, email, phone, password);
      return User.fromJson(response['user']);
    } catch (e) {
      throw e;
    }
  }

  Future<void> sendOtp(String phone) async {
    try {
      await _authService.sendOtp(phone);
    } catch (e) {
      throw e;
    }
  }

  Future<User> verifyOtp(String phone, String otp) async {
    try {
      final response = await _authService.verifyOtp(phone, otp);
      return User.fromJson(response['user']);
    } catch (e) {
      throw e;
    }
  }

  Future<void> logout() async {
    try {
      await _authService.logout();
    } catch (e) {
      throw e;
    }
  }

  Future<User> refreshToken() async {
    try {
      final response = await _authService.refreshToken();
      return User.fromJson(response['user']);
    } catch (e) {
      throw e;
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      await _authService.forgotPassword(email);
    } catch (e) {
      throw e;
    }
  }

  Future<void> resetPassword(String token, String newPassword) async {
    try {
      await _authService.resetPassword(token, newPassword);
    } catch (e) {
      throw e;
    }
  }
}
