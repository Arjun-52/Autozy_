import '../../core/utils/app_logger.dart';
import '../services/api_service.dart';
import '../models/dto/tickets_response_model.dart';

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
}
