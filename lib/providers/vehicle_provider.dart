import 'package:flutter/foundation.dart';
import '../data/repositories/vehicle_repository.dart';
import '../data/models/vehicle_model.dart';

class VehicleProvider extends ChangeNotifier {
  final VehicleRepository _vehicleRepository;

  List<Vehicle> _vehicles = [];
  bool _isLoading = false;
  String? _error;

  VehicleProvider(this._vehicleRepository);

  List<Vehicle> get vehicles => _vehicles;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchVehicles(String userId) async {
    _setLoading(true);
    _clearError();

    try {
      _vehicles = await _vehicleRepository.getVehicles(userId);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<Vehicle> getVehicleById(String vehicleId) async {
    _clearError();

    try {
      return await _vehicleRepository.getVehicleById(vehicleId);
    } catch (e) {
      _setError(e.toString());
      rethrow;
    }
  }

  Future<void> createVehicle(Vehicle vehicle) async {
    _setLoading(true);
    _clearError();

    try {
      final newVehicle = await _vehicleRepository.createVehicle(vehicle);
      _vehicles.add(newVehicle);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateVehicle(Vehicle vehicle) async {
    _setLoading(true);
    _clearError();

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
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteVehicle(String vehicleId) async {
    _setLoading(true);
    _clearError();

    try {
      await _vehicleRepository.deleteVehicle(vehicleId);
      _vehicles.removeWhere((vehicle) => vehicle.id == vehicleId);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<List<Vehicle>> searchVehicles(String query) async {
    _clearError();

    try {
      return await _vehicleRepository.searchVehicles(query);
    } catch (e) {
      _setError(e.toString());
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
