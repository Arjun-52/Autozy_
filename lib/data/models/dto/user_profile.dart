class UserProfile {
  final String id;
  final String phone;
  final String name;
  final String? email;
  final bool isActive;
  final String deviceId;
  final DateTime? lastActiveAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<dynamic> vehicles;
  final List<dynamic> subscriptions;
  final int vehicleCount;
  final int activeSubscriptions;

  UserProfile({
    required this.id,
    required this.phone,
    required this.name,
    this.email,
    required this.isActive,
    required this.deviceId,
    this.lastActiveAt,
    required this.createdAt,
    required this.updatedAt,
    required this.vehicles,
    required this.subscriptions,
    required this.vehicleCount,
    required this.activeSubscriptions,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        id: json['id'] ?? '',
        phone: json['phone'] ?? '',
        name: json['name'] ?? '',
        email: json['email'],
        isActive: json['is_active'] ?? false,
        deviceId: json['device_id'] ?? '',
        lastActiveAt: json['last_active_at'] != null ? DateTime.parse(json['last_active_at']) : null,
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
        vehicles: json['vehicles'] ?? [],
        subscriptions: json['subscriptions'] ?? [],
        vehicleCount: json['vehicleCount'] ?? 0,
        activeSubscriptions: json['activeSubscriptions'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'phone': phone,
        'name': name,
        if (email != null) 'email': email,
        'is_active': isActive,
        'device_id': deviceId,
        if (lastActiveAt != null) 'last_active_at': lastActiveAt!.toIso8601String(),
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
        'vehicles': vehicles,
        'subscriptions': subscriptions,
        'vehicleCount': vehicleCount,
        'activeSubscriptions': activeSubscriptions,
      };
}
