import 'package:flutter/material.dart';
import '../core/utils/app_logger.dart';
import '../data/models/dto/ticket_details_response_model.dart';
import '../data/repositories/ticket_repository.dart';

enum TicketDetailsState { initial, loading, success, error }

class TicketDetailsProvider extends ChangeNotifier {
  final TicketRepository _repository;

  TicketDetailsProvider(this._repository);

  TicketDetailsModel? _ticketDetails;
  TicketDetailsState _status = TicketDetailsState.initial;
  String? _errorMessage;

  TicketDetailsModel? get ticketDetails => _ticketDetails;
  TicketDetailsState get status => _status;
  String? get errorMessage => _errorMessage;

  Future<void> fetchTicketDetails(String ticketId, {bool isRefresh = false}) async {
    if (_status == TicketDetailsState.loading) return;

    if (isRefresh) {
      AppLogger.info('Refresh triggered for Ticket Details ID: $ticketId', tag: 'Tickets');
      _status = TicketDetailsState.loading;
      _errorMessage = null;
      notifyListeners();
    } else {
      _status = TicketDetailsState.loading;
      _errorMessage = null;
      _ticketDetails = null;
      notifyListeners();
    }

    try {
      AppLogger.info('Ticket details requested for ID: $ticketId', tag: 'Tickets');
      final response = await _repository.getTicketDetails(ticketId);

      _ticketDetails = response;
      _status = TicketDetailsState.success;
      AppLogger.info('Ticket loaded for ID: $ticketId', tag: 'Tickets');
      AppLogger.info('Replies loaded count: ${response.replies.length} for TicketId: $ticketId', tag: 'Tickets');
    } catch (e) {
      _status = TicketDetailsState.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      AppLogger.error('Errors while loading ticket details for ID: $ticketId', tag: 'Tickets', error: e);
    } finally {
      notifyListeners();
    }
  }
}
