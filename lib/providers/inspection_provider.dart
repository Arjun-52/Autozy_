import 'package:flutter/foundation.dart';
import '../data/repositories/inspection_repository.dart';
import '../../data/models/booking_model.dart';

class InspectionProvider extends ChangeNotifier {
  final InspectionRepository _inspectionRepository;

  List<Booking> _inspections = [];
  List<Booking> _upcomingInspections = [];
  List<Booking> _pastInspections = [];
  bool _isLoading = false;
  String? _error;

  InspectionProvider(this._inspectionRepository);

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

      final inspection = _inspections.firstWhere((i) => i.id == inspectionId);
      final updatedInspection = inspection.copyWith(status: 'cancelled');

      final index = _inspections.indexWhere((i) => i.id == inspectionId);
      if (index != -1) {
        _inspections[index] = updatedInspection;
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

      final inspection = _inspections.firstWhere((i) => i.id == inspectionId);
      final updatedInspection = inspection.copyWith(status: 'completed');

      final index = _inspections.indexWhere((i) => i.id == inspectionId);
      if (index != -1) {
        _inspections[index] = updatedInspection;
      }

      _upcomingInspections.removeWhere((i) => i.id == inspectionId);
      _pastInspections.add(updatedInspection);

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
}
