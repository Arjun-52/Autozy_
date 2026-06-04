import '../vehicle_model.dart';

class UpdateVehicleResponse {
  final bool success;
  final String? timestamp;
  final Vehicle? data;

  UpdateVehicleResponse({
    required this.success,
    this.timestamp,
    this.data,
  });

  factory UpdateVehicleResponse.fromJson(Map<String, dynamic> json) {
    return UpdateVehicleResponse(
      success: json['success'] ?? false,
      timestamp: json['timestamp'],
      data: json['data'] != null ? Vehicle.fromJson(json['data']) : null,
    );
  }
}
