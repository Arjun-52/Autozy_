class AddVehicleRequest {
  final String vehicleNumber;
  final String brand;
  final String model;
  final String sizeCategory;
  final double parkingLocationLat;
  final double parkingLocationLng;
  final String parkingNotes;

  AddVehicleRequest({
    required this.vehicleNumber,
    required this.brand,
    required this.model,
    required this.sizeCategory,
    required this.parkingLocationLat,
    required this.parkingLocationLng,
    required this.parkingNotes,
  });

  Map<String, dynamic> toJson() {
    return {
      'vehicleNumber': vehicleNumber.trim(),
      'brand': brand.trim(),
      'model': model.trim(),
      'sizeCategory': sizeCategory.trim(),
      'parkingLocationLat': parkingLocationLat,
      'parkingLocationLng': parkingLocationLng,
      'parkingNotes': parkingNotes.trim(),
    };
  }

  static String? validateField(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }
}
