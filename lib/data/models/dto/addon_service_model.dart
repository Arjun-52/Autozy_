class AddOnService {
  final String id;
  final String name;
  final String? description;
  final int? estimatedDuration;
  final double? price;
  final String? pricingId;

  AddOnService({
    required this.id,
    required this.name,
    this.description,
    this.estimatedDuration,
    this.price,
    this.pricingId,
  });

  factory AddOnService.fromJson(Map<String, dynamic> json) {
    return AddOnService(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString(),
      estimatedDuration: json['estimatedDuration'] as int? ?? json['estimated_duration'] as int?,
      price: json['price'] != null ? double.tryParse(json['price'].toString()) : null,
      pricingId: json['pricingId']?.toString() ?? json['pricing_id']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'id': id,
      'name': name,
    };
    if (description != null) map['description'] = description;
    if (estimatedDuration != null) map['estimatedDuration'] = estimatedDuration;
    if (price != null) map['price'] = price;
    if (pricingId != null) map['pricingId'] = pricingId;
    return map;
  }
}

typedef AddonServiceModel = AddOnService;
