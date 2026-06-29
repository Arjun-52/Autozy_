import 'dart:io';
import 'package:flutter/foundation.dart';
import '../../core/utils/app_logger.dart';
import '../services/api_service.dart';
import '../models/vehicle_model.dart';
import '../models/dto/add_vehicle_request.dart';
import '../models/dto/add_vehicle_response.dart';
import '../models/dto/delete_vehicle_response.dart';
import '../models/dto/update_vehicle_request.dart';
import '../models/dto/update_vehicle_response.dart';
import '../models/dto/vehicle_list_response.dart';
import '../models/dto/upload_image_response.dart';

class VehicleRepository {
  final ApiService _apiService;

  VehicleRepository(this._apiService);

  Future<UploadedImageModel> uploadVehicleImage(File imageFile) async {
    try {
      AppLogger.info('Vehicle image upload started: ${imageFile.path}', tag: 'Upload');
      final data = await _apiService.postMultipart(
        '/api/v1/upload/image',
        filePath: imageFile.path,
        fieldName: 'file',
      );
      final response = UploadImageResponse.fromJson(data);
      if (response.success && response.data != null) {
        AppLogger.info('Vehicle image upload completed successfully. Key: ${response.data!.key}', tag: 'Upload');
        return response.data!;
      } else {
        AppLogger.error('Vehicle image upload failed: Invalid response', tag: 'Upload');
        throw Exception('Failed to upload vehicle image: Invalid response');
      }
    } catch (e, st) {
      AppLogger.error('API failure: Failed to upload vehicle image', tag: 'Upload', error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> uploadVehicleImageForId(String vehicleId, File imageFile) async {
    debugPrint("First line inside uploadVehicleImage()");
    try {
      AppLogger.info('Vehicle specific image upload started for ID: $vehicleId, path: ${imageFile.path}', tag: 'Upload');
      debugPrint("Before the HTTP POST to /vehicles/{id}/image");
      final data = await _apiService.postMultipart(
        '/api/v1/vehicles/$vehicleId/image',
        filePath: imageFile.path,
        fieldName: 'file',
      );
      debugPrint("After the HTTP response");
      AppLogger.info('Vehicle specific image upload response: $data', tag: 'Upload');
      return data;
    } catch (e, st) {
      debugPrint("Exception in uploadVehicleImageForId: $e");
      debugPrint("Stacktrace: $st");
      AppLogger.error('API failure: Failed to upload vehicle image for ID: $vehicleId', tag: 'Upload', error: e, stackTrace: st);
      rethrow;
    }
  }

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
