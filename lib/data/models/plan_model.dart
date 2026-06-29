class Plan {
  final String id;
  final String name;
  final String description;
  final bool? isActive;
  final String? createdAt;
  final PlanFeatures? features;

  Plan({
    required this.id,
    required this.name,
    required this.description,
    this.isActive,
    this.createdAt,
    this.features,
  });

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      isActive: json['isActive'] as bool? ?? json['is_active'] as bool? ?? true,
      createdAt: json['createdAt'] as String? ?? json['created_at'] as String?,
      features: json['features'] != null
          ? PlanFeatures.fromJson(json['features'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'isActive': isActive,
      'createdAt': createdAt,
      'features': features?.toJson(),
    };
  }

  Plan copyWith({
    String? id,
    String? name,
    String? description,
    bool? isActive,
    String? createdAt,
    PlanFeatures? features,
  }) {
    return Plan(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      features: features ?? this.features,
    );
  }
}

class PlanFeatures {
  final int? internal;
  final int? waterWash;
  final int? washesPerMonth;
  final List<String> included;
  final List<String> excluded;

  PlanFeatures({
    this.internal,
    this.waterWash,
    this.washesPerMonth,
    this.included = const [],
    this.excluded = const [],
  });

  static List<String> _parseList(dynamic raw) {
    if (raw is List) {
      return raw.map((e) => e.toString()).where((e) => e.trim().isNotEmpty).toList();
    }
    return const [];
  }

  factory PlanFeatures.fromJson(Map<String, dynamic> json) {
    return PlanFeatures(
      internal: json['internal'] as int? ?? json['internal_cleaning'] as int?,
      waterWash: json['waterWash'] as int? ?? json['water_wash'] as int? ?? json['waterWashCount'] as int?,
      washesPerMonth: json['washes_per_month'] as int? ?? json['washesPerMonth'] as int?,
      included: _parseList(json['included']),
      excluded: _parseList(json['excluded']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'internal': internal,
      'waterWash': waterWash,
      'washesPerMonth': washesPerMonth,
      'included': included,
      'excluded': excluded,
    };
  }
}
