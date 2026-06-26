class PromotionModel {
  final String id;
  final String title;
  final String? description;
  final String? discountCode;
  final String? imageUrl;
  final String? actionUrl;
  final DateTime? validUntil;
  final bool isActive;

  PromotionModel({
    required this.id,
    required this.title,
    this.description,
    this.discountCode,
    this.imageUrl,
    this.actionUrl,
    this.validUntil,
    this.isActive = true,
  });

  factory PromotionModel.fromJson(Map<String, dynamic> json) {
    final validRaw = json['validUntil'] ?? json['valid_until'];
    return PromotionModel(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      description: json['description']?.toString(),
      discountCode: json['discountCode'] ?? json['discount_code'],
      imageUrl: json['imageUrl'] ?? json['image_url'],
      actionUrl: json['actionUrl'] ?? json['action_url'],
      validUntil: validRaw != null ? DateTime.tryParse(validRaw.toString()) : null,
      isActive: json['isActive'] ?? json['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'discount_code': discountCode,
      'image_url': imageUrl,
      'action_url': actionUrl,
      'valid_until': validUntil?.toIso8601String(),
      'is_active': isActive,
    };
  }
}
