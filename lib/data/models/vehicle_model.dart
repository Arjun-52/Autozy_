class Vehicle {
  final String id;
  final String userId;
  final String name;
  final String number;
  final String type;
  final String brand;
  final String model;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  Vehicle({
    required this.id,
    required this.userId,
    required this.name,
    required this.number,
    required this.type,
    required this.brand,
    required this.model,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      number: json['number'] ?? '',
      type: json['type'] ?? '',
      brand: json['brand'] ?? '',
      model: json['model'] ?? '',
      imageUrl: json['imageUrl'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'number': number,
      'type': type,
      'brand': brand,
      'model': model,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Vehicle copyWith({
    String? id,
    String? userId,
    String? name,
    String? number,
    String? type,
    String? brand,
    String? model,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Vehicle(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      number: number ?? this.number,
      type: type ?? this.type,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
