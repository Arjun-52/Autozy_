class AddonServiceModel {
  final String id;
  final String name;
  final String? description;
  final double? price;

  AddonServiceModel({
    required this.id,
    required this.name,
    this.description,
    this.price,
  });

  factory AddonServiceModel.fromJson(Map<String, dynamic> json) {
    return AddonServiceModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString(),
      // Try multiple common fields for price to be resilient to backend field name variations
      price: (() {
        final keys = ['price', 'amount', 'cost', 'service_price', 'servicePrice'];
        for (final k in keys) {
          if (json[k] != null) return double.tryParse(json[k].toString());
        }
        return null;
      })(),
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'id': id,
      'name': name,
    };
    if (description != null) map['description'] = description;
    if (price != null) map['price'] = price;
    return map;
  }
}
