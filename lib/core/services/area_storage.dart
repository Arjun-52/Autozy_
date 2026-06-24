import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../utils/app_logger.dart';
import '../../data/models/dto/nearby_areas_response.dart';

/// Persists the user's selected service area across app restarts.
///
/// The area is chosen once on the post-login area-selection screen and is
/// required at checkout. Without persistence it is lost whenever the app is
/// restarted with a restored session (splash skips area selection), which
/// surfaces as "Please select a service area first" at checkout.
///
/// Mirrors [TokenStorage]; backed by [SharedPreferences].
class AreaStorage {
  static const String _selectedAreaKey = 'selected_service_area';

  Future<void> saveSelectedArea(Area area) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedAreaKey, json.encode(area.toJson()));
    AppLogger.debug('Selected area persisted: ${area.name}', tag: 'AreaStorage');
  }

  Future<Area?> getSelectedArea() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_selectedAreaKey);
    if (raw == null || raw.isEmpty) return null;
    try {
      return Area.fromJson(json.decode(raw) as Map<String, dynamic>);
    } catch (e) {
      AppLogger.error('Failed to decode persisted area', tag: 'AreaStorage', error: e);
      return null;
    }
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_selectedAreaKey);
    AppLogger.debug('Selected area cleared', tag: 'AreaStorage');
  }
}
