import '../../core/utils/app_logger.dart';
import '../services/api_service.dart';
import '../models/dto/tickets_response_model.dart';
import '../models/dto/ticket_details_response_model.dart';

class TicketRepository {
  final ApiService _apiService;

  TicketRepository(this._apiService);

  Future<TicketsResponseModel> getMyTickets({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      AppLogger.info('Tickets requested. Page: $page, limit: $limit', tag: 'Tickets');

      final data = await _apiService.get(
        '/api/v1/tickets',
        queryParameters: {
          'page': page.toString(),
          'limit': limit.toString(),
        },
      );

      final response = TicketsResponseModel.fromJson(data);
      AppLogger.info('Tickets loaded. Count: ${response.data.length}', tag: 'Tickets');

      if (response.meta != null) {
        AppLogger.info('Pagination loaded. Total: ${response.meta!.total}, TotalPages: ${response.meta!.totalPages}', tag: 'Tickets');
      }

      return response;
    } catch (e, st) {
      AppLogger.error('Failed to load tickets', tag: 'Tickets', error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<TicketDetailsModel> getTicketDetails(String ticketId) async {
    try {
      AppLogger.info('Ticket details requested. TicketId: $ticketId', tag: 'Tickets');

      final data = await _apiService.get('/api/v1/tickets/$ticketId');
      final response = TicketDetailsResponseModel.fromJson(data);

      if (response.data == null) {
        throw Exception('Ticket details empty or format mismatch');
      }

      AppLogger.info('Ticket details loaded. TicketId: $ticketId, replies count: ${response.data!.replies.length}', tag: 'Tickets');
      return response.data!;
    } catch (e, st) {
      AppLogger.error('Failed to load ticket details for ID: $ticketId', tag: 'Tickets', error: e, stackTrace: st);
      rethrow;
    }
  }
}
