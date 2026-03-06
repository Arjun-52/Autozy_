class Plan {
  final String id;
  final String name;
  final String description;
  final double price;
  final String duration;
  final List<String> features;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Plan({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.duration,
    required this.features,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      duration: json['duration'] ?? '',
      features: List<String>.from(json['features'] ?? []),
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'duration': duration,
      'features': features,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Plan copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? duration,
    List<String>? features,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Plan(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      duration: duration ?? this.duration,
      features: features ?? this.features,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
