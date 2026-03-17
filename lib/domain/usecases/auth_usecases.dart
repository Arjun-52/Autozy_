import '../../data/repositories/auth_repository.dart';
import '../../data/models/user_model.dart';

/// Use cases for authentication business logic
class AuthUseCases {
  final AuthRepository _authRepository;
  
  AuthUseCases(this._authRepository);
  
  /// Login with phone validation
  Future<User> login(String phone, String password) async {
    if (!_isValidPhone(phone)) {
      throw ArgumentError('Invalid phone number format');
    }
    
    return await _authRepository.login(phone, password);
  }
  
  /// Register with validation
  Future<User> register(String name, String email, String phone, String password) async {
    if (!_isValidPhone(phone)) {
      throw ArgumentError('Invalid phone number format');
    }
    
    if (!_isValidEmail(email)) {
      throw ArgumentError('Invalid email format');
    }
    
    return await _authRepository.register(name, email, phone, password);
  }
  
  /// Send OTP with validation
  Future<void> sendOtp(String phone) async {
    if (!_isValidPhone(phone)) {
      throw ArgumentError('Invalid phone number format');
    }
    
    await _authRepository.sendOtp(phone);
  }
  
  /// Verify OTP
  Future<User> verifyOtp(String phone, String otp) async {
    if (otp.length != 4) {
      throw ArgumentError('OTP must be 4 digits');
    }
    
    return await _authRepository.verifyOtp(phone, otp);
  }
  
  /// Private validation methods
  bool _isValidPhone(String phone) {
    RegExp regex = RegExp(r'^[6-9]\d{9}$');
    return regex.hasMatch(phone);
  }
  
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
