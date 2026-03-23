import 'package:flutter/material.dart';
import '../data/repositories/auth_repository.dart';
import '../data/models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;

  AuthProvider(this._authRepository);

  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  /// PHONE VALIDATION
  bool _isValidPhone(String phone) {
    final regex = RegExp(r'^[6-9]\d{9}$');
    return regex.hasMatch(phone);
  }

  /// SEND OTP
  Future<bool> continueWithPhone(String phone) async {
    phone = phone.trim();

    if (!_isValidPhone(phone)) {
      _setError("Enter a valid 10 digit mobile number");
      notifyListeners();
      return false;
    }

    _setLoading(true);
    _clearError();
    notifyListeners();

    try {
      await _authRepository.sendOtp(phone);
      return true;
    } catch (e) {
      // Better error handling for debugging
      String errorMessage = "Failed to send OTP";

      if (e.toString().contains('Connection refused')) {
        errorMessage =
            "Server not responding. Please check your internet connection.";
      } else if (e.toString().contains('timeout')) {
        errorMessage = "Request timed out. Please try again.";
      } else if (e.toString().contains('No internet')) {
        errorMessage = "No internet connection. Please check your network.";
      } else {
        errorMessage = "Failed to send OTP: ${e.toString()}";
      }

      _setError(errorMessage);
      return false;
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  /// VERIFY OTP
  Future<bool> verifyOtpAndLogin(String phone, String otp) async {
    if (otp.length != 4) {
      _setError("Please enter complete OTP");
      notifyListeners();
      return false;
    }

    _setLoading(true);
    _clearError();
    notifyListeners();

    try {
      _user = await _authRepository.verifyOtp(phone, otp);
      return true;
    } catch (e) {
      _setError("Invalid OTP");
      return false;
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  /// LOGOUT
  Future<void> logout() async {
    _setLoading(true);
    _clearError();
    notifyListeners();

    try {
      await _authRepository.logout();
      _user = null;
    } catch (e) {
      _setError("Logout failed");
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  ///HELPERS
  void _setLoading(bool value) {
    _isLoading = value;
  }

  void _setError(String message) {
    _error = message;
  }

  void _clearError() {
    _error = null;
  }
}
