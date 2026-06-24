class Vehicle {
  final String id;
  final String userId;
  final String vehicleNumber;
  final String brand;
  final String model;
  final String sizeCategory;
  final double parkingLocationLat;
  final double parkingLocationLng;
  final String parkingNotes;
  final String? pillarNumber;
  final String? keyHandoverType;
  final bool parkingLotAvailable;
  final bool securityPermissionRequired;
  final bool isActive;
  final String status; // 'PENDING', 'APPROVED', 'REJECTED'
  final DateTime createdAt;

  // Legacy field compatibility
  String get name => '$brand $model';
  String get number => vehicleNumber;
  String get type => sizeCategory;
  String? get imageUrl => null;
  DateTime get updatedAt => createdAt;

  Vehicle({
    required this.id,
    required this.userId,
    required this.vehicleNumber,
    required this.brand,
    required this.model,
    required this.sizeCategory,
    required this.parkingLocationLat,
    required this.parkingLocationLng,
    required this.parkingNotes,
    this.pillarNumber,
    this.keyHandoverType,
    required this.parkingLotAvailable,
    required this.securityPermissionRequired,
    required this.isActive,
    required this.status,
    required this.createdAt,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    // Handle double conversion safely (in case they come as int or String)
    double parseDouble(dynamic val) {
      if (val == null) return 0.0;
      if (val is num) return val.toDouble();
      return double.tryParse(val.toString()) ?? 0.0;
    }

    return Vehicle(
      id: json['id'] ?? '',
      userId: json['userId'] ?? json['user_id'] ?? '',
      vehicleNumber: json['vehicleNumber'] ?? json['vehicle_number'] ?? json['number'] ?? '',
      brand: json['brand'] ?? '',
      model: json['model'] ?? '',
      sizeCategory: json['sizeCategory'] ?? json['size_category'] ?? json['type'] ?? '',
      parkingLocationLat: parseDouble(json['parkingLocationLat'] ?? json['parking_location_lat']),
      parkingLocationLng: parseDouble(json['parkingLocationLng'] ?? json['parking_location_lng']),
      parkingNotes: json['parkingNotes'] ?? json['parking_notes'] ?? '',
      pillarNumber: json['pillarNumber'] ?? json['pillar_number'],
      keyHandoverType: json['keyHandoverType'] ?? json['key_handover_type'],
      parkingLotAvailable: json['parkingLotAvailable'] ?? json['parking_lot_available'] ?? false,
      securityPermissionRequired: json['securityPermissionRequired'] ?? json['security_permission_required'] ?? false,
      isActive: json['isActive'] ?? json['is_active'] ?? true,
      status: json['status'] ?? 'PENDING',
      createdAt: DateTime.parse(json['createdAt'] ?? json['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'user_id': userId,
      'vehicleNumber': vehicleNumber,
      'vehicle_number': vehicleNumber,
      'brand': brand,
      'model': model,
      'sizeCategory': sizeCategory,
      'size_category': sizeCategory,
      'parkingLocationLat': parkingLocationLat,
      'parking_location_lat': parkingLocationLat,
      'parkingLocationLng': parkingLocationLng,
      'parking_location_lng': parkingLocationLng,
      'parkingNotes': parkingNotes,
      'parking_notes': parkingNotes,
      'pillarNumber': pillarNumber,
      'pillar_number': pillarNumber,
      'keyHandoverType': keyHandoverType,
      'key_handover_type': keyHandoverType,
      'parkingLotAvailable': parkingLotAvailable,
      'parking_lot_available': parkingLotAvailable,
      'securityPermissionRequired': securityPermissionRequired,
      'security_permission_required': securityPermissionRequired,
      'isActive': isActive,
      'is_active': isActive,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  Vehicle copyWith({
    String? id,
    String? userId,
    String? vehicleNumber,
    String? brand,
    String? model,
    String? sizeCategory,
    double? parkingLocationLat,
    double? parkingLocationLng,
    String? parkingNotes,
    String? pillarNumber,
    String? keyHandoverType,
    bool? parkingLotAvailable,
    bool? securityPermissionRequired,
    bool? isActive,
    String? status,
    DateTime? createdAt,
  }) {
    return Vehicle(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      sizeCategory: sizeCategory ?? this.sizeCategory,
      parkingLocationLat: parkingLocationLat ?? this.parkingLocationLat,
      parkingLocationLng: parkingLocationLng ?? this.parkingLocationLng,
      parkingNotes: parkingNotes ?? this.parkingNotes,
      pillarNumber: pillarNumber ?? this.pillarNumber,
      keyHandoverType: keyHandoverType ?? this.keyHandoverType,
      parkingLotAvailable: parkingLotAvailable ?? this.parkingLotAvailable,
      securityPermissionRequired: securityPermissionRequired ?? this.securityPermissionRequired,
      isActive: isActive ?? this.isActive,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
