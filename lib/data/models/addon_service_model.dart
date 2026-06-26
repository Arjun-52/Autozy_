class AddonServiceModel {
  final String id;
  final String name;
  final String description;
  final int? estimatedDuration;
  final num? price;
  final String? pricingId;
  final String? imageUrl;

  AddonServiceModel({
    required this.id,
    required this.name,
    required this.description,
    this.estimatedDuration,
    this.price,
    this.pricingId,
    this.imageUrl,
  });

  /// Display price like "₹1,499" (falls back to empty when unknown).
  String get priceLabel {
    if (price == null) return '';
    final whole = price!.round();
    final str = whole.toString();
    // Simple Indian-style grouping for the common 4-6 digit case.
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      final fromEnd = str.length - i;
      buffer.write(str[i]);
      if (fromEnd > 1 && (fromEnd - 1) % 3 == 0 && fromEnd != str.length) {
        buffer.write(',');
      }
    }
    return '₹${buffer.toString()}';
  }

  factory AddonServiceModel.fromJson(Map<String, dynamic> json) {
    return AddonServiceModel(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      estimatedDuration: json['estimatedDuration'] as int? ??
          json['estimated_duration_minutes'] as int?,
      price: json['price'] as num?,
      pricingId: json['pricingId'] ?? json['pricing_id'],
      imageUrl: json['imageUrl'] ?? json['image_url'],
    );
  }
}
