import 'package:flutter/material.dart';
import '../data/repositories/auth_repository.dart';
import '../data/models/dto/home_dashboard_response.dart';
import '../core/utils/app_logger.dart';

class HomeProvider extends ChangeNotifier {
  final AuthRepository _authRepository;

  HomeProvider(this._authRepository);

  HomeDashboardData? _dashboardData;
  bool _isLoading = false;
  String? _error;

  HomeDashboardData? get dashboardData => _dashboardData;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchDashboard() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    AppLogger.info('Controller fetch started', tag: 'HomeController');

    try {
      final response = await _authRepository.getHomeDashboard();
      if (response.success && response.data != null) {
        _dashboardData = response.data;
        AppLogger.info('Controller fetch success', tag: 'HomeController');
        AppLogger.info('UI state updates: success', tag: 'HomeController');
      } else {
        _error = 'Failed to load dashboard data';
        AppLogger.error('Controller fetch failure: Invalid response data', tag: 'HomeController');
        AppLogger.info('UI state updates: error', tag: 'HomeController');
      }
    } catch (e, st) {
      _error = e.toString();
      AppLogger.error('Controller fetch failure', tag: 'HomeController', error: e, stackTrace: st);
      AppLogger.info('UI state updates: error', tag: 'HomeController');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
