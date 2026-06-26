import 'dart:io';
import '../../core/utils/app_logger.dart';
import '../services/api_service.dart';
import '../models/vehicle_model.dart';
import '../models/dto/add_vehicle_request.dart';
import '../models/dto/add_vehicle_response.dart';
import '../models/dto/delete_vehicle_response.dart';
import '../models/dto/update_vehicle_request.dart';
import '../models/dto/update_vehicle_response.dart';
import '../models/dto/vehicle_list_response.dart';
class VehicleRepository {
  final ApiService _apiService;

  VehicleRepository(this._apiService);

  Future<VehicleListResponse> getVehicles({int page = 1, int limit = 20}) async {
    try {
      AppLogger.info('Fetching vehicles list (page: $page, limit: $limit)', tag: 'Vehicles');
      final data = await _apiService.get(
        '/api/v1/vehicles',
        queryParameters: {'page': page.toString(), 'limit': limit.toString()},
      );
      return VehicleListResponse.fromJson(data);
    } catch (e, st) {
      AppLogger.error('Failed to fetch vehicles', tag: 'Vehicles', error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<Vehicle> getVehicleById(String vehicleId) async {
    try {
      final data = await _apiService.get('/api/v1/vehicles/$vehicleId');
      final vehicleData = data['data'] ?? data['vehicle'];
      return Vehicle.fromJson(vehicleData);
    } catch (e, st) {
      AppLogger.error('Failed to fetch vehicle by ID: $vehicleId', tag: 'Vehicles', error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<AddVehicleResponse> createVehicle({
    required AddVehicleRequest request,
  }) async {
    try {
      AppLogger.info('Vehicle creation initiated', tag: 'Vehicles');
      AppLogger.info('Vehicle number submitted: ${request.vehicleNumber}', tag: 'Vehicles');
      AppLogger.info('Vehicle request started', tag: 'Vehicles');
      
      final reqBody = request.toJson();
      print('CREATE VEHICLE REQUEST BODY: $reqBody');

      final data = await _apiService.post(
        '/api/v1/vehicles',
        data: reqBody,
      );
      
      print('CREATE VEHICLE RESPONSE DATA: $data');

      final response = AddVehicleResponse.fromJson(data);
      AppLogger.info('Vehicle creation success. Created vehicle ID: ${response.data?.id}', tag: 'Vehicles');
      return response;
    } catch (e, st) {
      print('REPOSITORY CREATE VEHICLE EXCEPTION: $e');
      print(st);
      AppLogger.error('API failures: Vehicle creation failed', tag: 'Vehicles', error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<Vehicle> updateVehicle(String vehicleId, Vehicle vehicle) async {
    try {
      final data = await _apiService.put(
        '/api/v1/vehicles/$vehicleId',
        data: vehicle.toJson(),
      );
      final vehicleData = data['data'] ?? data['vehicle'];
      return Vehicle.fromJson(vehicleData);
    } catch (e, st) {
      AppLogger.error('Failed to update vehicle: $vehicleId', tag: 'Vehicles', error: e, stackTrace: st);
      rethrow;
    }
  }

  // PATCH vehicle for partial updates
  Future<UpdateVehicleResponse> patchVehicle(String vehicleId, UpdateVehicleRequest request) async {
    try {
      final data = await _apiService.patch(
        '/api/v1/vehicles/$vehicleId',
        data: request.toJson(),
      );
      return UpdateVehicleResponse.fromJson(data);
    } catch (e, st) {
      AppLogger.error('Failed to patch vehicle: $vehicleId', tag: 'Vehicles', error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<DeleteVehicleResponse> deleteVehicle(String vehicleId) async {
    try {
      AppLogger.info('Vehicle deletion initiated', tag: 'Vehicles');
      AppLogger.info('Vehicle ID used: $vehicleId', tag: 'Vehicles');
      AppLogger.info('Delete request started', tag: 'Vehicles');
      
      final data = await _apiService.delete('/api/v1/vehicles/$vehicleId');
      final response = DeleteVehicleResponse.fromJson(data);
      
      AppLogger.info('Delete request success', tag: 'Vehicles');
      return response;
    } catch (e, st) {
      AppLogger.error('API failures: Failed to delete vehicle: $vehicleId', tag: 'Vehicles', error: e, stackTrace: st);
      rethrow;
    }
  }

  /// Fetches the list of vehicle brands from GET /api/v1/vehicle-data/brands.
  Future<List<String>> getVehicleBrands() async {
    try {
      final data = await _apiService.get('/api/v1/vehicle-data/brands');
      final List<dynamic> list = data['data'] ?? data['brands'] ?? [];
      return list
          .map((e) => e is String ? e : (e['name'] ?? e['brand'] ?? e.toString()).toString())
          .where((e) => e.trim().isNotEmpty)
          .toList();
    } catch (e, st) {
      AppLogger.error('Failed to fetch vehicle brands', tag: 'Vehicles', error: e, stackTrace: st);
      rethrow;
    }
  }

  /// Fetches models for a brand from GET /api/v1/vehicle-data/models?brand=.
  Future<List<String>> getVehicleModels(String brand) async {
    try {
      final data = await _apiService.get(
        '/api/v1/vehicle-data/models',
        queryParameters: {'brand': brand},
      );
      final List<dynamic> list = data['data'] ?? data['models'] ?? [];
      return list
          .map((e) => e is String ? e : (e['name'] ?? e['model'] ?? e.toString()).toString())
          .where((e) => e.trim().isNotEmpty)
          .toList();
    } catch (e, st) {
      AppLogger.error('Failed to fetch vehicle models for $brand', tag: 'Vehicles', error: e, stackTrace: st);
      rethrow;
    }
  }

  /// Uploads a vehicle image (multipart, field name `file`) to
  /// POST /api/v1/vehicles/:id/image and returns the updated vehicle.
  Future<Vehicle> uploadVehicleImage(String vehicleId, File imageFile) async {
    try {
      AppLogger.info('Uploading vehicle image for: $vehicleId', tag: 'Vehicles');
      final data = await _apiService.postMultipart(
        '/api/v1/vehicles/$vehicleId/image',
        filePath: imageFile.path,
        fieldName: 'file',
      );
      final vehicleData = data['data'] ?? data['vehicle'] ?? data;
      return Vehicle.fromJson(vehicleData);
    } catch (e, st) {
      AppLogger.error('Failed to upload vehicle image: $vehicleId', tag: 'Vehicles', error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<List<Vehicle>> searchVehicles(String query) async {
    try {
      final data = await _apiService.get(
        '/api/v1/vehicles/search',
        queryParameters: {'q': query},
      );

      final List<dynamic> vehiclesData = data['data'] ?? data['vehicles'] ?? [];
      return vehiclesData.map((vehicle) => Vehicle.fromJson(vehicle)).toList();
    } catch (e, st) {
      AppLogger.error('Failed to search vehicles: $query', tag: 'Vehicles', error: e, stackTrace: st);
      rethrow;
    }
  }
}
