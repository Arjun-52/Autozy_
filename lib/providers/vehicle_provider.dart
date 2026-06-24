import 'package:flutter/foundation.dart';
import '../../core/utils/app_logger.dart';
import '../data/repositories/vehicle_repository.dart';
import '../data/models/vehicle_model.dart';
import '../data/models/dto/add_vehicle_request.dart';
import '../data/models/dto/update_vehicle_request.dart';

class VehicleProvider extends ChangeNotifier {
  final VehicleRepository _vehicleRepository;

  List<Vehicle> _vehicles = [];
  Vehicle? _selectedVehicle;
  bool _isLoading = false;
  String? _error;
  String? _patchStatus; // 'loading', 'success', 'error', null

  Vehicle? _createdVehicle;
  String? _creationStatus; // 'loading', 'success', 'error', null
  String? _deleteStatus; // 'loading', 'success', 'error', null

  // Pagination state
  int _currentPage = 1;
  int _totalPages = 1;
  bool _isListLoading = false;
  bool _isPageLoading = false;
  String? _listError;

  VehicleProvider(this._vehicleRepository);

  List<Vehicle> get vehicles => _vehicles;
  Vehicle? get selectedVehicle => _selectedVehicle;
  bool get isLoading => _isLoading; // legacy loading for create/delete actions
  String? get error => _error;

  /// The vehicle the user picked for the current booking. Used by checkout.
  void selectVehicle(Vehicle vehicle) {
    _selectedVehicle = vehicle;
    notifyListeners();
  }

  // Pagination getters
  bool get isListLoading => _isListLoading;
  bool get isPageLoading => _isPageLoading;
  String? get listError => _listError;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;

  Vehicle? get createdVehicle => _createdVehicle;
  String? get creationStatus => _creationStatus;
  String? get deleteStatus => _deleteStatus;
  String? get patchStatus => _patchStatus;

  Future<void> fetchVehicles({int page = 1, int limit = 20, bool reset = false}) async {
    if (reset) {
      _vehicles.clear();
      _currentPage = 1;
      _totalPages = 1;
    }

    // set appropriate loading flag
    if (page == 1) {
      _isListLoading = true;
    } else {
      _isPageLoading = true;
    }
    _listError = null;
    notifyListeners();

    try {
      final response = await _vehicleRepository.getVehicles(page: page, limit: limit);
      final fetched = response.vehicles ?? [];
      _currentPage = response.meta?.page ?? page;
      _totalPages = response.meta?.totalPages ?? 1;

      if (reset) {
        _vehicles = fetched;
      } else {
        _vehicles.addAll(fetched);
      }
    } catch (e) {
      _listError = e.toString();
    } finally {
      if (page == 1) {
        _isListLoading = false;
      } else {
        _isPageLoading = false;
      }
      notifyListeners();
    }
  }

  Future<void> refreshVehicles({int limit = 20}) async {
    await fetchVehicles(page: 1, limit: limit, reset: true);
  }

  Future<void> loadMore({int limit = 20}) async {
    if (_currentPage >= _totalPages) return;
    await fetchVehicles(page: _currentPage + 1, limit: limit);
  }

  Future<Vehicle> getVehicleById(String vehicleId) async {
    _error = null;
    try {
      return await _vehicleRepository.getVehicleById(vehicleId);
    } catch (e) {
      _error = e.toString();
      rethrow;
    }
  }

  Future<bool> createVehicle({required AddVehicleRequest request}) async {
    _isLoading = true;
    _creationStatus = 'loading';
    _error = null;
    notifyListeners();

    try {
      final response = await _vehicleRepository.createVehicle(request: request);
      if (response.success && response.data != null) {
        _createdVehicle = response.data;
        _vehicles.add(response.data!);
        _creationStatus = 'success';
        AppLogger.info('Vehicle synchronization triggered', tag: 'Vehicles');
        notifyListeners();
        return true;
      } else {
        _creationStatus = 'error';
        _error = 'Unable to add vehicle';
        notifyListeners();
        return false;
      }
    } catch (e, st) {
      print('PROVIDER CREATE VEHICLE EXCEPTION: $e');
      print(st);
      _creationStatus = 'error';
      String msg = e.toString();
      if (msg.contains('Exception:')) {
        msg = msg.replaceAll('Exception: ', '');
      }
      _error = msg;
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateVehicle(Vehicle vehicle) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedVehicle = await _vehicleRepository.updateVehicle(
        vehicle.id,
        vehicle,
      );
      final index = _vehicles.indexWhere((v) => v.id == vehicle.id);
      if (index != -1) {
        _vehicles[index] = updatedVehicle;
      }
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // PATCH partial update
  Future<bool> patchVehicle(String vehicleId, UpdateVehicleRequest request) async {
    _patchStatus = 'loading';
    _error = null;
    notifyListeners();
    try {
      final response = await _vehicleRepository.patchVehicle(vehicleId, request);
      if (response.success) {
        // refresh vehicle list
        await refreshVehicles();
        _patchStatus = 'success';
        notifyListeners();
        return true;
      } else {
        _patchStatus = 'error';
        _error = 'Patch failed';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _patchStatus = 'error';
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteVehicle(String vehicleId) async {
    _isLoading = true;
    _deleteStatus = 'loading';
    _error = null;
    notifyListeners();

    try {
      AppLogger.info('Vehicle deletion initiated', tag: 'Vehicles');
      AppLogger.info('Vehicle ID used: $vehicleId', tag: 'Vehicles');
      AppLogger.info('Delete request started', tag: 'Vehicles');

      final response = await _vehicleRepository.deleteVehicle(vehicleId);
      
      if (response.success) {
        _vehicles.removeWhere((vehicle) => vehicle.id == vehicleId);
        _deleteStatus = 'success';
        AppLogger.info('Delete request success', tag: 'Vehicles');
        AppLogger.info('Vehicle removed from state', tag: 'Vehicles');
        // refresh list to keep pagination meta correct
        await refreshVehicles();
        notifyListeners();
        return true;
      } else {
        _deleteStatus = 'error';
        _error = 'Unable to remove vehicle';
        AppLogger.error('API failures: Unable to remove vehicle', tag: 'Vehicles');
        notifyListeners();
        return false;
      }
    } catch (e, st) {
      _deleteStatus = 'error';
      String msg = e.toString();
      if (msg.contains('Exception:')) {
        msg = msg.replaceAll('Exception: ', '');
      }
      _error = msg;
      AppLogger.error('API failures: Failed to delete vehicle: $vehicleId', tag: 'Vehicles', error: e, stackTrace: st);
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<Vehicle>> searchVehicles(String query) async {
    _error = null;
    try {
      return await _vehicleRepository.searchVehicles(query);
    } catch (e) {
      _error = e.toString();
      rethrow;
    }
  }

  void addVehicle(Vehicle vehicle) {
    _vehicles.add(vehicle);
    notifyListeners();
  }

  void removeVehicle(String vehicleId) {
    _vehicles.removeWhere((vehicle) => vehicle.id == vehicleId);
    notifyListeners();
  }

  void clearVehicles() {
    _vehicles.clear();
    notifyListeners();
  }
}
