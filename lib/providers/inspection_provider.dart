import 'dart:io';
import 'package:flutter/foundation.dart';
import '../../core/utils/app_logger.dart';
import '../data/models/dto/upload_image_response.dart';
import '../data/repositories/inspection_repository.dart';
import '../../data/models/booking_model.dart';

class InspectionProvider extends ChangeNotifier {
  final InspectionRepository _inspectionRepository;

  List<Booking> _inspections = [];
  List<Booking> _upcomingInspections = [];
  List<Booking> _pastInspections = [];
  bool _isLoading = false;
  String? _error;

  // Image Upload State
  String? _uploadedImageUrl;
  String? _uploadedImageKey;
  String _uploadStatus = 'initial'; // 'initial', 'uploading', 'success', 'error'
  String? _uploadError;

  // Multiple Image Upload State
  List<UploadedImageModel> _uploadedImagesList = [];
  List<String> _uploadedImageUrls = [];
  List<String> _uploadedImageKeys = [];
  String _multipleUploadStatus = 'initial'; // 'initial', 'uploading', 'success', 'error'
  String? _multipleUploadError;

  InspectionProvider(this._inspectionRepository);

  List<UploadedImageModel> get uploadedImagesList => _uploadedImagesList;
  List<String> get uploadedImageUrls => _uploadedImageUrls;
  List<String> get uploadedImageKeys => _uploadedImageKeys;
  String get multipleUploadStatus => _multipleUploadStatus;
  String? get multipleUploadError => _multipleUploadError;

  String? get uploadedImageUrl => _uploadedImageUrl;
  String? get uploadedImageKey => _uploadedImageKey;
  String get uploadStatus => _uploadStatus;
  String? get uploadError => _uploadError;

  List<Booking> get inspections => _inspections;
  List<Booking> get upcomingInspections => _upcomingInspections;
  List<Booking> get pastInspections => _pastInspections;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchInspections(String userId) async {
    _setLoading(true);
    _clearError();

    try {
      _inspections = await _inspectionRepository.getInspections(userId);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchUpcomingInspections(String userId) async {
    _setLoading(true);
    _clearError();

    try {
      _upcomingInspections = await _inspectionRepository.getUpcomingInspections(
        userId,
      );
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchPastInspections(String userId) async {
    _setLoading(true);
    _clearError();

    try {
      _pastInspections = await _inspectionRepository.getPastInspections(userId);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<Booking> getInspectionById(String inspectionId) async {
    _clearError();

    try {
      return await _inspectionRepository.getInspectionById(inspectionId);
    } catch (e) {
      _setError(e.toString());
      rethrow;
    }
  }

  Future<void> scheduleInspection(
    String bookingId,
    DateTime inspectionDate,
  ) async {
    _setLoading(true);
    _clearError();

    try {
      final newInspection = await _inspectionRepository.scheduleInspection(
        bookingId,
        inspectionDate,
      );
      _inspections.add(newInspection);

      if (inspectionDate.isAfter(DateTime.now())) {
        _upcomingInspections.add(newInspection);
      } else {
        _pastInspections.add(newInspection);
      }

      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> rescheduleInspection(
    String inspectionId,
    DateTime newDate,
  ) async {
    _setLoading(true);
    _clearError();

    try {
      final updatedInspection = await _inspectionRepository
          .rescheduleInspection(inspectionId, newDate);

      final index = _inspections.indexWhere((i) => i.id == inspectionId);
      if (index != -1) {
        _inspections[index] = updatedInspection;
      }

      final upcomingIndex = _upcomingInspections.indexWhere(
        (i) => i.id == inspectionId,
      );
      if (upcomingIndex != -1) {
        _upcomingInspections.removeAt(upcomingIndex);
      }

      final pastIndex = _pastInspections.indexWhere(
        (i) => i.id == inspectionId,
      );
      if (pastIndex != -1) {
        _pastInspections.removeAt(pastIndex);
      }

      if (newDate.isAfter(DateTime.now())) {
        _upcomingInspections.add(updatedInspection);
      } else {
        _pastInspections.add(updatedInspection);
      }

      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> cancelInspection(String inspectionId) async {
    _setLoading(true);
    _clearError();

    try {
      await _inspectionRepository.cancelInspection(inspectionId);

      final index = _inspections.indexWhere((i) => i.id == inspectionId);
      if (index != -1) {
        _inspections[index] = _inspections[index].copyWith(status: 'cancelled');
      }

      _upcomingInspections.removeWhere((i) => i.id == inspectionId);
      _pastInspections.removeWhere((i) => i.id == inspectionId);

      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> completeInspection(
    String inspectionId,
    Map<String, dynamic> inspectionData,
  ) async {
    _setLoading(true);
    _clearError();

    try {
      await _inspectionRepository.completeInspection(
        inspectionId,
        inspectionData,
      );

      final index = _inspections.indexWhere((i) => i.id == inspectionId);
      Booking? updatedInspection;
      if (index != -1) {
        updatedInspection = _inspections[index].copyWith(status: 'completed');
        _inspections[index] = updatedInspection;
      }

      _upcomingInspections.removeWhere((i) => i.id == inspectionId);
      if (updatedInspection != null) {
        _pastInspections.add(updatedInspection);
      }

      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<Map<String, dynamic>> getInspectionReport(String inspectionId) async {
    _clearError();

    try {
      return await _inspectionRepository.getInspectionReport(inspectionId);
    } catch (e) {
      _setError(e.toString());
      rethrow;
    }
  }

  void clearInspections() {
    _inspections.clear();
    _upcomingInspections.clear();
    _pastInspections.clear();
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  Future<bool> uploadImage(File file) async {
    _uploadStatus = 'uploading';
    _uploadError = null;
    notifyListeners();
    AppLogger.info('Upload started inside provider for: ${file.path}', tag: 'Upload');

    try {
      final data = await _inspectionRepository.uploadImage(file);
      _uploadedImageUrl = data.url;
      _uploadedImageKey = data.key;
      _uploadStatus = 'success';
      AppLogger.info('Upload response received in provider: URL=${data.url}, Key=${data.key}', tag: 'Upload');
      notifyListeners();
      return true;
    } catch (e) {
      _uploadStatus = 'error';
      _uploadError = e.toString();
      AppLogger.error('Upload failed inside provider: $e', tag: 'Upload');
      notifyListeners();
      return false;
    }
  }

  void resetUpload() {
    _uploadedImageUrl = null;
    _uploadedImageKey = null;
    _uploadStatus = 'initial';
    _uploadError = null;
    notifyListeners();
  }

  Future<bool> uploadMultipleImages(List<File> files) async {
    if (files.isEmpty) {
      _multipleUploadStatus = 'error';
      _multipleUploadError = 'Empty selection: No files selected for upload';
      notifyListeners();
      return false;
    }
    if (files.length > 5) {
      _multipleUploadStatus = 'error';
      _multipleUploadError = 'Maximum image limit exceeded: You cannot upload more than 5 images';
      notifyListeners();
      return false;
    }

    _multipleUploadStatus = 'uploading';
    _multipleUploadError = null;
    notifyListeners();
    AppLogger.info('Multiple upload started inside provider for: ${files.length} images', tag: 'Upload');

    try {
      final data = await _inspectionRepository.uploadMultipleImages(files);
      _uploadedImagesList = data;
      _uploadedImageUrls = data.map((img) => img.url).toList();
      _uploadedImageKeys = data.map((img) => img.key).toList();
      _multipleUploadStatus = 'success';
      AppLogger.info('Multiple upload response received in provider. Count: ${data.length}', tag: 'Upload');
      notifyListeners();
      return true;
    } catch (e) {
      _multipleUploadStatus = 'error';
      _multipleUploadError = e.toString();
      AppLogger.error('Multiple upload failed inside provider: $e', tag: 'Upload');
      notifyListeners();
      return false;
    }
  }

  void resetMultipleUpload() {
    _uploadedImagesList = [];
    _uploadedImageUrls = [];
    _uploadedImageKeys = [];
    _multipleUploadStatus = 'initial';
    _multipleUploadError = null;
    notifyListeners();
  }
}
