import 'package:flutter/material.dart';
import '../../core/utils/app_logger.dart';
import '../data/models/dto/service_calendar_response.dart';
import '../data/repositories/daily_service_repository.dart';

enum DailyServiceCalendarStatus { initial, loading, success, empty, error }

class DailyCalendarProvider extends ChangeNotifier {
  final DailyServiceRepository _repository;

  DailyCalendarProvider(this._repository);

  ServiceCalendarModel? _calendarData;
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;
  DailyServiceCalendarStatus _status = DailyServiceCalendarStatus.initial;
  String? _errorMessage;
  
  // Selected day details
  String? _selectedDayKey;
  ServiceCalendarDayModel? _selectedDayDetails;

  ServiceCalendarModel? get calendarData => _calendarData;
  int get selectedMonth => _selectedMonth;
  int get selectedYear => _selectedYear;
  DailyServiceCalendarStatus get status => _status;
  String? get errorMessage => _errorMessage;
  String? get selectedDayKey => _selectedDayKey;
  ServiceCalendarDayModel? get selectedDayDetails => _selectedDayDetails;

  Future<void> fetchCalendar(String vehicleId, {bool isRefresh = false}) async {
    _status = DailyServiceCalendarStatus.loading;
    _errorMessage = null;
    if (isRefresh) {
      AppLogger.info('Refresh triggered for service calendar', tag: 'DailyService');
    }
    notifyListeners();

    try {
      final data = await _repository.getServiceCalendar(vehicleId: vehicleId);
      _calendarData = data;
      _selectedMonth = data.month;
      _selectedYear = data.year;

      if (data.days.isEmpty) {
        _status = DailyServiceCalendarStatus.empty;
      } else {
        _status = DailyServiceCalendarStatus.success;
      }

      // Auto-select first available service day or clear
      if (data.days.isNotEmpty) {
        final sortedKeys = data.days.keys.toList()..sort((a, b) => int.parse(a).compareTo(int.parse(b)));
        _selectedDayKey = sortedKeys.first;
        _selectedDayDetails = data.days[_selectedDayKey];
      } else {
        _selectedDayKey = null;
        _selectedDayDetails = null;
      }
    } catch (e) {
      final errorStr = e.toString().toLowerCase();
      if (errorStr.contains('invalid time value')) {
        _status = DailyServiceCalendarStatus.empty;
        _calendarData = null;
        _selectedDayKey = null;
        _selectedDayDetails = null;
      } else {
        _status = DailyServiceCalendarStatus.error;
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      }
    } finally {
      notifyListeners();
    }
  }

  void selectDay(String dayKey) {
    AppLogger.info('Date selected: day $dayKey', tag: 'DailyService');
    _selectedDayKey = dayKey;
    if (_calendarData != null && _calendarData!.days.containsKey(dayKey)) {
      _selectedDayDetails = _calendarData!.days[dayKey];
    } else {
      _selectedDayDetails = null;
    }
    notifyListeners();
  }

  void changeMonth(String vehicleId, bool next) {
    // Note: The GET /api/v1/daily-service/calendar endpoint from API currently takes vehicleId.
    // If backend returns data for dynamic month/year parameters, we would pass them.
    // For now we navigate months locally and trigger reload.
    if (next) {
      if (_selectedMonth == 12) {
        _selectedMonth = 1;
        _selectedYear++;
      } else {
        _selectedMonth++;
      }
    } else {
      if (_selectedMonth == 1) {
        _selectedMonth = 12;
        _selectedYear--;
      } else {
        _selectedMonth--;
      }
    }
    AppLogger.info('Month changed to $_selectedMonth/$_selectedYear', tag: 'DailyService');
    
    // In standard calendar mock/backend, we reload the API data for that month.
    fetchCalendar(vehicleId);
  }
}
