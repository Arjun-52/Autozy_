import 'dart:convert';
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

  Future<TicketModel> createTicket({
    required String type,
    required String vehicleId,
    String? subscriptionId,
    String? serviceDate,
    required String description,
    List<String>? proofPhotos,
  }) async {
    try {
      AppLogger.info('Creating ticket: type=$type, vehicleId=$vehicleId', tag: 'Tickets');

      final requestData = {
        'type': type,
        'vehicleId': vehicleId,
        if (subscriptionId != null &&
            subscriptionId.isNotEmpty &&
            subscriptionId != "null" &&
            subscriptionId != "undefined")
          'subscriptionId': subscriptionId,
        if (serviceDate != null &&
            serviceDate.isNotEmpty &&
            serviceDate != "null" &&
            serviceDate != "undefined")
          'serviceDate': serviceDate,
        'description': description,
        'proofPhotos': proofPhotos ?? [],
      };

      final data = await () async {
        print("ACTUAL_PAYLOAD: ${jsonEncode(requestData)}");
        AppLogger.info('POST /api/v1/tickets payload: ${jsonEncode(requestData)}', tag: 'Tickets');
        return await _apiService.post('/api/v1/tickets', data: requestData);
      }();
      final responseData = data['data'];
      if (responseData == null) {
        throw Exception(data['message'] ?? 'Failed to create ticket');
      }

      AppLogger.info('Ticket created successfully', tag: 'Tickets');
      return TicketModel.fromJson(responseData);
    } catch (e, st) {
      print("TICKET_CREATION_FAILED_ERROR: $e");
      AppLogger.error('Failed to create ticket', tag: 'Tickets', error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<String> uploadImage(String filePath) async {
    try {
      AppLogger.info('Uploading proof photo: $filePath', tag: 'Tickets');
      final data = await _apiService.postMultipart(
        '/api/v1/upload/image',
        filePath: filePath,
        fieldName: 'file',
      );
      final responseData = data['data'];
      if (responseData == null || responseData['url'] == null) {
        throw Exception(data['message'] ?? 'Failed to upload image');
      }
      return responseData['url'].toString();
    } catch (e) {
      rethrow;
    }
  }
}
