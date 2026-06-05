import 'package:shared_preferences/shared_preferences.dart';

import '../utils/app_logger.dart';

/// Persists the auth tokens across app restarts so the user stays logged in.
///
/// Backed by [SharedPreferences]. Swap the implementation here (e.g. for
/// `flutter_secure_storage`) without touching callers.
class TokenStorage {
  static const String _accessKey = 'auth_access_token';
  static const String _refreshKey = 'auth_refresh_token';

  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessKey, accessToken);
    if (refreshToken != null && refreshToken.isNotEmpty) {
      await prefs.setString(_refreshKey, refreshToken);
    }
    AppLogger.debug('Tokens persisted', tag: 'TokenStorage');
  }

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessKey);
  }

  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshKey);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessKey);
    await prefs.remove(_refreshKey);
    AppLogger.debug('Tokens cleared', tag: 'TokenStorage');
  }
}
