class UpdateVehicleRequest {
  final String? brand;
  final String? model;
  final double? parkingLocationLat;
  final double? parkingLocationLng;
  final String? parkingNotes;
  final String? vehicleImage;

  UpdateVehicleRequest({
    this.brand,
    this.model,
    this.parkingLocationLat,
    this.parkingLocationLng,
    this.parkingNotes,
    this.vehicleImage,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (brand != null) map['brand'] = brand;
    if (model != null) map['model'] = model;
    if (parkingLocationLat != null) map['parkingLocationLat'] = parkingLocationLat;
    if (parkingLocationLng != null) map['parkingLocationLng'] = parkingLocationLng;
    if (parkingNotes != null) map['parkingNotes'] = parkingNotes;
    // TODO: Backend support does not exist yet. Add 'vehicleImage' when backend is ready.
    return map;
  }
}
