import '../services/api_service.dart';
import 'package:autozy/data/models/booking_model.dart';

class InspectionRepository {
  final ApiService _apiService;

  InspectionRepository(this._apiService);

  Future<List<Booking>> getInspections(String userId) async {
    try {
      final data = await _apiService.get(
        '/inspections',
        queryParameters: {'userId': userId},
      );

      final List<dynamic> inspections = data['inspections'];
      return inspections
          .map((inspection) => Booking.fromJson(inspection))
          .toList();
    } catch (e) {
      throw e;
    }
  }

  Future<Booking> getInspectionById(String inspectionId) async {
    try {
      final data = await _apiService.get('/inspections/$inspectionId');
      return Booking.fromJson(data['inspection']);
    } catch (e) {
      throw e;
    }
  }

  Future<Booking> scheduleInspection(
    String bookingId,
    DateTime inspectionDate,
  ) async {
    try {
      final data = await _apiService.post(
        '/inspections',
        data: {
          'bookingId': bookingId,
          'inspectionDate': inspectionDate.toIso8601String(),
        },
      );
      return Booking.fromJson(data['inspection']);
    } catch (e) {
      throw e;
    }
  }

  Future<Booking> rescheduleInspection(
    String inspectionId,
    DateTime newDate,
  ) async {
    try {
      final data = await _apiService.patch(
        '/inspections/$inspectionId/reschedule',
        data: {'newDate': newDate.toIso8601String()},
      );
      return Booking.fromJson(data['inspection']);
    } catch (e) {
      throw e;
    }
  }

  Future<void> cancelInspection(String inspectionId) async {
    try {
      await _apiService.patch('/inspections/$inspectionId/cancel');
    } catch (e) {
      throw e;
    }
  }

  Future<void> completeInspection(
    String inspectionId,
    Map<String, dynamic> results,
  ) async {
    try {
      await _apiService.patch(
        '/inspections/$inspectionId/complete',
        data: results,
      );
    } catch (e) {
      throw e;
    }
  }

  Future<Booking> updateInspection(
    String inspectionId,
    Booking inspection,
  ) async {
    try {
      final data = await _apiService.put(
        '/inspections/$inspectionId',
        data: inspection.toJson(),
      );
      return Booking.fromJson(data['inspection']);
    } catch (e) {
      throw e;
    }
  }

  Future<Booking> createInspection(Booking inspection) async {
    try {
      final data = await _apiService.post(
        '/inspections',
        data: inspection.toJson(),
      );
      return Booking.fromJson(data['inspection']);
    } catch (e) {
      throw e;
    }
  }

  Future<Map<String, dynamic>> getInspectionReport(String inspectionId) async {
    try {
      final data = await _apiService.get('/inspections/$inspectionId/report');
      return data['report'];
    } catch (e) {
      throw e;
    }
  }

  Future<List<Booking>> getUpcomingInspections(String userId) async {
    try {
      final data = await _apiService.get(
        '/inspections/upcoming',
        queryParameters: {'userId': userId},
      );

      final List<dynamic> inspections = data['inspections'];
      return inspections
          .map((inspection) => Booking.fromJson(inspection))
          .toList();
    } catch (e) {
      throw e;
    }
  }

  Future<List<Booking>> getPastInspections(String userId) async {
    try {
      final data = await _apiService.get(
        '/inspections/past',
        queryParameters: {'userId': userId},
      );

      final List<dynamic> inspections = data['inspections'];
      return inspections
          .map((inspection) => Booking.fromJson(inspection))
          .toList();
    } catch (e) {
      throw e;
    }
  }

  Future<List<Map<String, dynamic>>> getInspectionHistory(
    String vehicleId,
  ) async {
    try {
      final data = await _apiService.get('/vehicles/$vehicleId/inspections');

      final List<dynamic> history = data['inspections'];
      return history.map((item) => item as Map<String, dynamic>).toList();
    } catch (e) {
      throw e;
    }
  }
}
