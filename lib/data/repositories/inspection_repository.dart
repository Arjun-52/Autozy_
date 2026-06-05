import 'dart:io';
import '../../core/utils/app_logger.dart';
import '../models/dto/upload_image_response.dart';
import '../models/dto/upload_multiple_images_response.dart';
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
      rethrow;
    }
  }

  Future<Booking> getInspectionById(String inspectionId) async {
    try {
      final data = await _apiService.get('/inspections/$inspectionId');
      return Booking.fromJson(data['inspection']);
    } catch (e) {
      rethrow;
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
      rethrow;
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
      rethrow;
    }
  }

  Future<void> cancelInspection(String inspectionId) async {
    try {
      await _apiService.patch('/inspections/$inspectionId/cancel');
    } catch (e) {
      rethrow;
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
      rethrow;
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
      rethrow;
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
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getInspectionReport(String inspectionId) async {
    try {
      final data = await _apiService.get('/inspections/$inspectionId/report');
      return data['report'];
    } catch (e) {
      rethrow;
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
      rethrow;
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
      rethrow;
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
      rethrow;
    }
  }

  Future<UploadedImageModel> uploadImage(File imageFile) async {
    try {
      AppLogger.info('Image upload started: ${imageFile.path}', tag: 'Upload');
      final data = await _apiService.postMultipart(
        '/api/v1/upload/image',
        filePath: imageFile.path,
        fieldName: 'file',
      );
      final response = UploadImageResponse.fromJson(data);
      if (response.success && response.data != null) {
        AppLogger.info('Image upload completed successfully. Key: ${response.data!.key}', tag: 'Upload');
        return response.data!;
      } else {
        AppLogger.error('Image upload failed: Invalid response', tag: 'Upload');
        throw Exception('Failed to upload image: Invalid response');
      }
    } catch (e, st) {
      AppLogger.error('API failure: Failed to upload image', tag: 'Upload', error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<List<UploadedImageModel>> uploadMultipleImages(List<File> imageFiles) async {
    if (imageFiles.isEmpty) {
      throw Exception('Empty selection: No files selected for upload');
    }
    if (imageFiles.length > 5) {
      throw Exception('Maximum image limit exceeded: You cannot upload more than 5 images');
    }

    try {
      AppLogger.info('Multiple image upload started. Count: ${imageFiles.length}', tag: 'Upload');
      final filePaths = imageFiles.map((f) => f.path).toList();
      final data = await _apiService.postMultipartMultiple(
        '/api/v1/upload/images',
        filePaths: filePaths,
        fieldName: 'files',
      );
      final response = UploadMultipleImagesResponse.fromJson(data);
      if (response.success) {
        AppLogger.info('Multiple image upload completed successfully. Count: ${response.data.length}', tag: 'Upload');
        return response.data;
      } else {
        AppLogger.error('Multiple image upload failed: Invalid response', tag: 'Upload');
        throw Exception('Failed to upload multiple images: Invalid response');
      }
    } catch (e, st) {
      AppLogger.error('API failure: Failed to upload multiple images', tag: 'Upload', error: e, stackTrace: st);
      rethrow;
    }
  }
}
