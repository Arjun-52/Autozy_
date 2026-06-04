class UpdateVehicleRequest {
  final String? brand;
  final String? model;
  final double? parkingLocationLat;
  final double? parkingLocationLng;
  final String? parkingNotes;

  UpdateVehicleRequest({
    this.brand,
    this.model,
    this.parkingLocationLat,
    this.parkingLocationLng,
    this.parkingNotes,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (brand != null) map['brand'] = brand;
    if (model != null) map['model'] = model;
    if (parkingLocationLat != null) map['parkingLocationLat'] = parkingLocationLat;
    if (parkingLocationLng != null) map['parkingLocationLng'] = parkingLocationLng;
    if (parkingNotes != null) map['parkingNotes'] = parkingNotes;
    return map;
  }
}
