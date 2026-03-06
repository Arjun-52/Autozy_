import 'package:flutter/foundation.dart';
import '../data/repositories/auth_repository.dart';
import '../data/models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;

  User? _user;
  bool _isLoading = false;
  String? _error;

  AuthProvider(this._authRepository);

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  Future<void> login(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      _user = await _authRepository.login(email, password);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> register(
    String name,
    String email,
    String phone,
    String password,
  ) async {
    _setLoading(true);
    _clearError();

    try {
      _user = await _authRepository.register(name, email, phone, password);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> sendOtp(String phone) async {
    _setLoading(true);
    _clearError();

    try {
      await _authRepository.sendOtp(phone);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> verifyOtp(String phone, String otp) async {
    _setLoading(true);
    _clearError();

    try {
      _user = await _authRepository.verifyOtp(phone, otp);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    _clearError();

    try {
      await _authRepository.logout();
      _user = null;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> refreshToken() async {
    try {
      _user = await _authRepository.refreshToken();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
      _user = null;
      notifyListeners();
    }
  }

  Future<void> forgotPassword(String email) async {
    _setLoading(true);
    _clearError();

    try {
      await _authRepository.forgotPassword(email);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> resetPassword(String token, String newPassword) async {
    _setLoading(true);
    _clearError();

    try {
      await _authRepository.resetPassword(token, newPassword);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  void updateUser(User user) {
    _user = user;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }
}
