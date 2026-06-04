import '../vehicle_model.dart';
import 'pagination_meta.dart';

class VehicleListResponse {
  final bool? success;
  final List<Vehicle>? vehicles;
  final PaginationMeta? meta;
  final String? timestamp;

  VehicleListResponse({
    this.success,
    this.vehicles,
    this.meta,
    this.timestamp,
  });

  factory VehicleListResponse.fromJson(Map<String, dynamic> json) {
    final vehiclesJson = json['data'] ?? json['vehicles'] ?? [];
    List<Vehicle> vehicleList = [];
    if (vehiclesJson is List) {
      vehicleList = vehiclesJson.map((e) => Vehicle.fromJson(e)).toList();
    }
    return VehicleListResponse(
      success: json['success'] as bool?,
      vehicles: vehicleList,
      meta: json['meta'] != null ? PaginationMeta.fromJson(json['meta']) : null,
      timestamp: json['timestamp'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'data': vehicles?.map((e) => e.toJson()).toList(),
        'meta': meta?.toJson(),
        'timestamp': timestamp,
      };
}
