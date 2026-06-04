class DeleteVehicleResponse {
  final bool success;
  final String? timestamp;

  DeleteVehicleResponse({
    required this.success,
    this.timestamp,
  });

  factory DeleteVehicleResponse.fromJson(Map<String, dynamic> json) {
    return DeleteVehicleResponse(
      success: json['success'] ?? false,
      timestamp: json['timestamp'],
    );
  }
}
