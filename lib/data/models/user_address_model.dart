class UserAddress {
  final String id;
  final String flatNo;
  final String building;
  final String locality;
  final String? landmark;
  final String city;
  final String state;
  final String pincode;
  final double? lat;
  final double? lng;
  final bool isDefault;

  UserAddress({
    required this.id,
    required this.flatNo,
    required this.building,
    required this.locality,
    this.landmark,
    required this.city,
    required this.state,
    required this.pincode,
    this.lat,
    this.lng,
    this.isDefault = false,
  });

  /// A single-line, human-readable summary of the address.
  String get formatted {
    final parts = [
      flatNo,
      building,
      locality,
      if (landmark != null && landmark!.isNotEmpty) landmark,
      city,
      state,
      pincode,
    ].where((p) => p != null && p.toString().trim().isNotEmpty).toList();
    return parts.join(', ');
  }

  factory UserAddress.fromJson(Map<String, dynamic> json) {
    double? parseDouble(dynamic val) {
      if (val == null) return null;
      if (val is num) return val.toDouble();
      return double.tryParse(val.toString());
    }

    return UserAddress(
      id: (json['id'] ?? '').toString(),
      flatNo: json['flatNo'] ?? json['flat_no'] ?? '',
      building: json['building'] ?? '',
      locality: json['locality'] ?? '',
      landmark: json['landmark'],
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      pincode: (json['pincode'] ?? '').toString(),
      lat: parseDouble(json['lat']),
      lng: parseDouble(json['lng']),
      isDefault: json['isDefault'] ?? json['is_default'] ?? false,
    );
  }

  /// Body for create/update requests. Omits server-managed fields.
  Map<String, dynamic> toRequestJson() {
    return {
      'flat_no': flatNo,
      'building': building,
      'locality': locality,
      if (landmark != null) 'landmark': landmark,
      'city': city,
      'state': state,
      'pincode': pincode,
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
      'is_default': isDefault,
    };
  }
}
