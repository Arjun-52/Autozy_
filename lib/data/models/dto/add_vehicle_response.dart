import '../vehicle_model.dart';

class AddVehicleResponse {
  final bool success;
  final Vehicle? data;
  final String? timestamp;

  AddVehicleResponse({
    required this.success,
    this.data,
    this.timestamp,
  });

  factory AddVehicleResponse.fromJson(Map<String, dynamic> json) {
    return AddVehicleResponse(
      success: json['success'] ?? false,
      data: json['data'] != null ? Vehicle.fromJson(json['data']) : null,
      timestamp: json['timestamp'],
    );
  }
}
