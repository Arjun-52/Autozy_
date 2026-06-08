import 'package:flutter/material.dart';

import '../data/repositories/auth_repository.dart';
import '../data/models/user_model.dart';
import '../data/models/dto/update_profile_request.dart';
import '../data/models/dto/user_profile.dart';
import '../data/models/dto/send_otp_request.dart';
import '../core/utils/app_logger.dart';
import '../core/router/go_router.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;

  AuthProvider(this._authRepository);

  // ----- Auth State -----
  User? _user;
  bool _isLoading = false;
  String? _error;
  String? _phone;
  String? _successMessage;
  String? _lastOtpRequestStatus;

  // ----- Profile State -----
  UserProfile? _profile;
  bool _profileLoading = false;
  String? _profileError;
  String? _profileSuccessMessage;

  // ----- Getters -----
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get phone => _phone;
  String? get successMessage => _successMessage;
  String? get lastOtpRequestStatus => _lastOtpRequestStatus;
  bool get isAuthenticated => _user != null;

  UserProfile? get profile => _profile;
  bool get profileLoading => _profileLoading;
  String? get profileError => _profileError;
  String? get profileSuccessMessage => _profileSuccessMessage;

  // ----- Helper Methods -----
  void _setLoading(bool value) {
    _isLoading = value;
  }

  void _setError(String message) {
    _error = message;
  }

  void _clearError() {
    _error = null;
  }

  // ----- Auth Actions -----
  void resetAuthState() {
    _phone = null;
    _successMessage = null;
    _lastOtpRequestStatus = null;
    _clearError();
    _setLoading(false);
    notifyListeners();
  }

  // SEND OTP
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
        _setError('Unable to send OTP');
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

  // VERIFY OTP AND LOGIN
  Future<bool> verifyOtpAndLogin(String phone, String otp) async {
    if (otp.length != 6) {
      _setError('Please enter complete OTP');
      notifyListeners();
      return false;
    }
    _setLoading(true);
    _clearError();
    notifyListeners();
    try {
      _user = await _authRepository.verifyOtp(phone, otp);
      _clearError();
      // Fetch user profile immediately after login to sync count and state
      await fetchUserProfile();
      return true;
    } catch (e) {
      _setError(e.toString().contains('Exception:') ? e.toString().replaceAll('Exception: ', '') : 'Invalid OTP');
      return false;
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  // LOGOUT
  Future<void> logout() async {
    _setLoading(true);
    _clearError();
    notifyListeners();
    try {
      await _authRepository.logout();
      _user = null;
      _profile = null;
    } catch (e) {
      _setError('Logout failed');
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  // FETCH USER PROFILE
  Future<void> fetchUserProfile() async {
    _profileLoading = true;
    _profileError = null;
    _profileSuccessMessage = null;
    notifyListeners();
    try {
      _profile = await _authRepository.getUserProfile();
      AppLogger.info('Profile user profile fetched successfully', tag: 'Auth');
    } catch (e) {
      _profileError = e.toString();
      AppLogger.error('Profile fetch error: $_profileError', tag: 'Auth');
    } finally {
      _profileLoading = false;
      notifyListeners();
    }
  }

  // UPDATE USER PROFILE
  Future<void> updateUserProfile({String? name, String? email}) async {
    _profileLoading = true;
    _profileError = null;
    _profileSuccessMessage = null;
    notifyListeners();
    try {
      final request = UpdateProfileRequest(name: name?.trim(), email: email?.trim());
      if ((request.name == null || request.name!.isEmpty) && (request.email == null || request.email!.isEmpty)) {
        throw Exception('No changes to update');
      }
      final updated = await _authRepository.updateUserProfile(request);
      _profile = updated;
      _profileSuccessMessage = 'Profile updated successfully';
      AppLogger.info('Profile update successful', tag: 'Auth');
    } catch (e) {
      _profileError = e.toString();
      AppLogger.error('Profile update error: $_profileError', tag: 'Auth');
    } finally {
      _profileLoading = false;
      notifyListeners();
    }
  }

  // HANDLE SESSION EXPIRED
  void handleSessionExpired() {
    _user = null;
    _profile = null;
    _phone = null;
    _successMessage = null;
    _lastOtpRequestStatus = null;
    _error = 'Session expired. Please log in again.';
    notifyListeners();
    AppGoRouter.router.go('/login');
  }
}
