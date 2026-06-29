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
    final hasVehicle = json['vehicle'] != null || json['data'] != null;
    return AddVehicleResponse(
      success: json['success'] ?? hasVehicle,
      data: json['data'] != null 
          ? Vehicle.fromJson(json['data']) 
          : (json['vehicle'] != null ? Vehicle.fromJson(json['vehicle']) : null),
      timestamp: json['timestamp'],
    );
  }
}
