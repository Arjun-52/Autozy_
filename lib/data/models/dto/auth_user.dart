class AuthUser {
  final String id;
  final String type;
  final String role;
  final String phone;
  final String name;

  AuthUser({
    required this.id,
    required this.type,
    required this.role,
    required this.phone,
    required this.name,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) => AuthUser(
        id: json['id'] ?? '',
        type: json['type'] ?? '',
        role: json['role'] ?? '',
        phone: json['phone'] ?? '',
        name: json['name'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'role': role,
        'phone': phone,
        'name': name,
      };
}
