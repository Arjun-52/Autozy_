import '../services/api_service.dart';
import '../models/vehicle_model.dart';

class VehicleRepository {
  final ApiService _apiService;

  VehicleRepository(this._apiService);

  Future<List<Vehicle>> getVehicles(String userId) async {
    try {
      final data = await _apiService.get(
        '/vehicles',
        queryParameters: {'userId': userId},
      );

      final List<dynamic> vehicles = data['vehicles'];
      return vehicles.map((vehicle) => Vehicle.fromJson(vehicle)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Vehicle> getVehicleById(String vehicleId) async {
    try {
      final data = await _apiService.get('/vehicles/$vehicleId');
      return Vehicle.fromJson(data['vehicle']);
    } catch (e) {
      rethrow;
    }
  }

  Future<Vehicle> createVehicle(Vehicle vehicle) async {
    try {
      final data = await _apiService.post('/vehicles', data: vehicle.toJson());
      return Vehicle.fromJson(data['vehicle']);
    } catch (e) {
      rethrow;
    }
  }

  Future<Vehicle> updateVehicle(String vehicleId, Vehicle vehicle) async {
    try {
      final data = await _apiService.put(
        '/vehicles/$vehicleId',
        data: vehicle.toJson(),
      );
      return Vehicle.fromJson(data['vehicle']);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteVehicle(String vehicleId) async {
    try {
      await _apiService.delete('/vehicles/$vehicleId');
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Vehicle>> searchVehicles(String query) async {
    try {
      final data = await _apiService.get(
        '/vehicles/search',
        queryParameters: {'q': query},
      );

      final List<dynamic> vehicles = data['vehicles'];
      return vehicles.map((vehicle) => Vehicle.fromJson(vehicle)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
