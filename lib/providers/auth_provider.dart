import 'package:flutter/material.dart';
import '../data/repositories/auth_repository.dart';
import '../data/models/user_model.dart';
import '../data/models/dto/send_otp_request.dart';
import '../core/utils/app_logger.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;

  AuthProvider(this._authRepository);

  User? _user;
  bool _isLoading = false;
  String? _error;
  String? _phone;
  String? _successMessage;
  String? _lastOtpRequestStatus;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get phone => _phone;
  String? get successMessage => _successMessage;
  String? get lastOtpRequestStatus => _lastOtpRequestStatus;
  bool get isAuthenticated => _user != null;

  void resetAuthState() {
    _phone = null;
    _successMessage = null;
    _lastOtpRequestStatus = null;
    _clearError();
    _setLoading(false);
    notifyListeners();
  }

  /// SEND OTP
  Future<bool> continueWithPhone(String phoneRaw) async {
    final validationError = SendOtpRequest.validatePhone(phoneRaw);
    if (validationError != null) {
      AppLogger.error('Validation failures: $validationError', tag: 'Auth');
      _setError(validationError);
      notifyListeners();
      return false;
    }

    final phoneTrimmed = phoneRaw.trim();
    _phone = phoneTrimmed;
    _setLoading(true);
    _clearError();
    _successMessage = null;
    _lastOtpRequestStatus = 'loading';
    notifyListeners();

    try {
      final response = await _authRepository.sendOtp(phoneTrimmed);
      if (response.success) {
        _successMessage = response.data?.message ?? "OTP Sent Successfully";
        _lastOtpRequestStatus = 'success';
        return true;
      } else {
        _lastOtpRequestStatus = 'failed';
        _setError("Unable to send OTP");
        return false;
      }
    } catch (e) {
      _lastOtpRequestStatus = 'failed';
      String rawError = e.toString();
      if (rawError.startsWith('Exception: ')) {
        rawError = rawError.substring('Exception: '.length);
      }

      String errorMessage = rawError;
      if (errorMessage.contains('Connection refused') || errorMessage.contains('SocketException')) {
        errorMessage = "Unable to send OTP";
      } else if (errorMessage.contains('timeout')) {
        errorMessage = "Request timed out. Please try again.";
      } else if (errorMessage.contains('No internet')) {
        errorMessage = "No internet connection. Please check your network.";
      } else if (errorMessage.contains('Rate limit exceeded')) {
        errorMessage = "Rate limit exceeded. Please try again later.";
      } else if (errorMessage.isEmpty || errorMessage == "null") {
        errorMessage = "Something went wrong";
      }

      AppLogger.error('API failures: $errorMessage', tag: 'Auth');
      _setError(errorMessage);
      return false;
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  /// VERIFY OTP
  Future<bool> verifyOtpAndLogin(String phone, String otp) async {
    if (otp.length != 6) {
      _setError("Please enter complete OTP");
      notifyListeners();
      return false;
    }

    _setLoading(true);
    _clearError();
    notifyListeners();

    try {
      _user = await _authRepository.verifyOtp(phone, otp);
      _clearError();
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
