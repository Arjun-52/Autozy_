class AddVehicleRequest {
  final String vehicleNumber;
  final String brand;
  final String model;
  final String sizeCategory;
  final double parkingLocationLat;
  final double parkingLocationLng;
  final String parkingNotes;
  final String flatNo;
  final String building;
  final String locality;
  final String landmark;
  final String city;
  final String state;
  final String pincode;
  final String? vehicleImage;

  AddVehicleRequest({
    required this.vehicleNumber,
    required this.brand,
    required this.model,
    required this.sizeCategory,
    required this.parkingLocationLat,
    required this.parkingLocationLng,
    required this.parkingNotes,
    required this.flatNo,
    required this.building,
    required this.locality,
    required this.landmark,
    required this.city,
    required this.state,
    required this.pincode,
    this.vehicleImage,
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
      'flatNo': flatNo.trim(),
      'building': building.trim(),
      'locality': locality.trim(),
      'landmark': landmark.trim(),
      'city': city.trim(),
      'state': state.trim(),
      'pincode': pincode.trim(),
      // TODO: Backend support does not exist yet. Add 'vehicleImage': vehicleImage when backend is ready.
    };
  }

  static String? validateField(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }
}
