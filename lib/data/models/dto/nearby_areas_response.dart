class NearbyAreasResponse {
  final bool? success;
  final List<Area>? areas;
  final String? timestamp;

  NearbyAreasResponse({
    this.success,
    this.areas,
    this.timestamp,
  });

  factory NearbyAreasResponse.fromJson(Map<String, dynamic> json) {
    final areasJson = json['data'] as List?;
    List<Area>? areasList;
    if (areasJson != null) {
      areasList = areasJson.map((e) => Area.fromJson(e as Map<String, dynamic>)).toList();
    }
    return NearbyAreasResponse(
      success: json['success'] as bool?,
      areas: areasList,
      timestamp: json['timestamp'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'data': areas?.map((e) => e.toJson()).toList(),
        'timestamp': timestamp,
      };
}

class Area {
  final String id;
  final String? cityId;
  final String name;
  final String? pincode;
  final String? centerLat;
  final String? centerLng;
  final String? radiusKm;
  final String? status;
  final int? maxCapacity;
  final int? currentSubscriptions;
  final bool? isOnboardingPaused;
  final bool? isActive;
  final int? availableSlots;
  final String? createdAt;
  final AreaCity? city;

  Area({
    required this.id,
    this.cityId,
    required this.name,
    this.pincode,
    this.centerLat,
    this.centerLng,
    this.radiusKm,
    this.status,
    this.maxCapacity,
    this.currentSubscriptions,
    this.isOnboardingPaused,
    this.isActive,
    this.availableSlots,
    this.createdAt,
    this.city,
  });

  factory Area.fromJson(Map<String, dynamic> json) {
    return Area(
      id: json['id'] as String? ?? '',
      cityId: json['city_id'] as String? ?? json['cityId'] as String?,
      name: json['name'] as String? ?? '',
      pincode: json['pincode'] as String?,
      centerLat: json['center_lat']?.toString() ?? json['centerLat']?.toString(),
      centerLng: json['center_lng']?.toString() ?? json['centerLng']?.toString(),
      radiusKm: json['radius_km']?.toString() ?? json['radiusKm']?.toString(),
      status: json['status'] as String?,
      maxCapacity: json['max_capacity'] as int? ?? json['maxCapacity'] as int?,
      currentSubscriptions: json['current_subscriptions'] as int? ?? json['currentSubscriptions'] as int?,
      isOnboardingPaused: json['is_onboarding_paused'] as bool? ?? json['isOnboardingPaused'] as bool?,
      isActive: json['is_active'] as bool? ?? json['isActive'] as bool?,
      availableSlots: json['availableSlots'] as int? ?? json['available_slots'] as int?,
      createdAt: json['created_at'] as String? ?? json['createdAt'] as String?,
      city: json['city'] != null ? AreaCity.fromJson(json['city'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'city_id': cityId,
        'name': name,
        'pincode': pincode,
        'center_lat': centerLat,
        'center_lng': centerLng,
        'radius_km': radiusKm,
        'status': status,
        'max_capacity': maxCapacity,
        'current_subscriptions': currentSubscriptions,
        'is_onboarding_paused': isOnboardingPaused,
        'is_active': isActive,
        'availableSlots': availableSlots,
        'created_at': createdAt,
        'city': city?.toJson(),
      };
}

class AreaCity {
  final String id;
  final String name;
  final String state;
  final bool? isActive;
  final String? createdAt;

  AreaCity({
    required this.id,
    required this.name,
    required this.state,
    this.isActive,
    this.createdAt,
  });

  factory AreaCity.fromJson(Map<String, dynamic> json) {
    return AreaCity(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      state: json['state'] as String? ?? '',
      isActive: json['is_active'] as bool? ?? json['isActive'] as bool?,
      createdAt: json['created_at'] as String? ?? json['createdAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'state': state,
        'is_active': isActive,
        'created_at': createdAt,
      };
}
