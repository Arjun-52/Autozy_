import 'package:flutter/material.dart';
import '../core/utils/app_logger.dart';
import '../data/models/dto/tickets_response_model.dart';
import '../data/repositories/ticket_repository.dart';

enum TicketStatusState { initial, loading, success, empty, error }

class TicketProvider extends ChangeNotifier {
  final TicketRepository _repository;

  TicketProvider(this._repository);

  List<TicketModel> _tickets = [];
  TicketsPaginationModel? _meta;
  TicketStatusState _status = TicketStatusState.initial;
  String? _errorMessage;
  bool _isPageLoading = false;

  List<TicketModel> get tickets => _tickets;
  TicketsPaginationModel? get meta => _meta;
  TicketStatusState get status => _status;
  String? get errorMessage => _errorMessage;
  bool get isPageLoading => _isPageLoading;

  Future<void> fetchTickets({bool isRefresh = false}) async {
    if (_status == TicketStatusState.loading || _isPageLoading) return;

    if (isRefresh) {
      AppLogger.info('Refresh triggered for My Tickets', tag: 'Tickets');
      _status = TicketStatusState.loading;
      _errorMessage = null;
      notifyListeners();
    } else {
      _status = TicketStatusState.loading;
      _errorMessage = null;
      _tickets = [];
      _meta = null;
      notifyListeners();
    }

    try {
      final response = await _repository.getMyTickets(page: 1, limit: 20);

      _tickets = response.data;
      _meta = response.meta;

      if (_tickets.isEmpty) {
        _status = TicketStatusState.empty;
      } else {
        _status = TicketStatusState.success;
      }
    } catch (e) {
      final errorStr = e.toString().toLowerCase();
      if (errorStr.contains('not found') || errorStr.contains('empty')) {
        _status = TicketStatusState.empty;
        _tickets = [];
        _meta = null;
      } else {
        _status = TicketStatusState.error;
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      }
    } finally {
      notifyListeners();
    }
  }

  Future<void> loadMore() async {
    if (_isPageLoading || _meta == null) return;

    final nextPage = _meta!.page + 1;
    if (nextPage > _meta!.totalPages) return;

    AppLogger.info('Pagination loaded. Loading page $nextPage of Tickets', tag: 'Tickets');
    _isPageLoading = true;
    notifyListeners();

    try {
      final response = await _repository.getMyTickets(page: nextPage, limit: 20);
      _tickets.addAll(response.data);
      _meta = response.meta;
    } catch (e) {
      AppLogger.error('Failed to load page $nextPage of Tickets', tag: 'Tickets', error: e);
    } finally {
      _isPageLoading = false;
      notifyListeners();
    }
  }
}
