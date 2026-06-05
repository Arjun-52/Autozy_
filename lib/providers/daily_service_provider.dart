import 'package:flutter/material.dart';
import '../../core/utils/app_logger.dart';
import '../data/models/dto/service_history_response.dart';
import '../data/repositories/daily_service_repository.dart';

enum DailyServiceHistoryStatus { initial, loading, success, empty, error }

class DailyServiceProvider extends ChangeNotifier {
  final DailyServiceRepository _repository;

  DailyServiceProvider(this._repository);

  List<ServiceHistoryModel> _historyList = [];
  ServiceHistoryMetaModel? _meta;
  DailyServiceHistoryStatus _status = DailyServiceHistoryStatus.initial;
  String? _errorMessage;
  bool _isPageLoading = false;

  List<ServiceHistoryModel> get historyList => _historyList;
  ServiceHistoryMetaModel? get meta => _meta;
  DailyServiceHistoryStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get isPageLoading => _isPageLoading;

  Future<void> fetchHistory(String vehicleId, {bool isRefresh = false}) async {
    if (_status == DailyServiceHistoryStatus.loading || _isPageLoading) {
      return;
    }

    if (isRefresh) {
      AppLogger.info('Refresh triggered for service history', tag: 'DailyService');
      _status = DailyServiceHistoryStatus.loading;
      _errorMessage = null;
      notifyListeners();
    } else {
      _status = DailyServiceHistoryStatus.loading;
      _errorMessage = null;
      _historyList = [];
      _meta = null;
      notifyListeners();
    }

    try {
      final paginatedData = await _repository.getServiceHistory(
        vehicleId: vehicleId,
        page: 1,
        limit: 10,
      );

      _historyList = paginatedData.data;
      _meta = paginatedData.meta;
      
      if (_historyList.isEmpty) {
        _status = DailyServiceHistoryStatus.empty;
      } else {
        _status = DailyServiceHistoryStatus.success;
      }
    } catch (e) {
      final errorStr = e.toString().toLowerCase();
      if (errorStr.contains('invalid time value')) {
        _status = DailyServiceHistoryStatus.empty;
        _historyList = [];
        _meta = null;
      } else {
        _status = DailyServiceHistoryStatus.error;
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      }
    } finally {
      notifyListeners();
    }
  }

  Future<void> loadMore(String vehicleId) async {
    if (_isPageLoading || _meta == null) return;
    
    final nextPage = (_meta!.page) + 1;
    if (nextPage > _meta!.totalPages) {
      return;
    }

    AppLogger.info('Pagination triggered for service history (next page: $nextPage)', tag: 'DailyService');
    _isPageLoading = true;
    notifyListeners();

    try {
      final paginatedData = await _repository.getServiceHistory(
        vehicleId: vehicleId,
        page: nextPage,
        limit: 10,
      );

      _historyList.addAll(paginatedData.data);
      _meta = paginatedData.meta;
    } catch (e) {
      AppLogger.error('Failed to load page $nextPage of service history', tag: 'DailyService', error: e);
    } finally {
      _isPageLoading = false;
      notifyListeners();
    }
  }
}
