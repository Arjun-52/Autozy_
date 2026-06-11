class SubscriptionResponse {
  final bool success;
  final List<SubscriptionModel>? data;
  final PaginationMeta? meta;
  final String? timestamp;

  SubscriptionResponse({
    required this.success,
    this.data,
    this.meta,
    this.timestamp,
  });

  factory SubscriptionResponse.fromJson(Map<String, dynamic> json) {
    return SubscriptionResponse(
      success: json['success'] as bool? ?? false,
      data: json['data'] != null
          ? (json['data'] as List)
              .map((item) => SubscriptionModel.fromJson(item as Map<String, dynamic>))
              .toList()
          : null,
      meta: json['meta'] != null
          ? PaginationMeta.fromJson(json['meta'] as Map<String, dynamic>)
          : null,
      timestamp: json['timestamp'] as String?,
    );
  }
}

class SubscriptionModel {
  final String id;
  final String status;
  final String? startDate;
  final String? endDate;
  final String? slotType;
  final VehicleModel? vehicle;
  final PlanPricingModel? planPricing;
  final CityModel? city;
  final String? refundStatus;
  final int? refundAmount;
  final String? refundReason;
  final String? refundInitiatedAt;
  final String? refundCompletedAt;
  final int? platformFee;

  SubscriptionModel({
    required this.id,
    required this.status,
    this.startDate,
    this.endDate,
    this.slotType,
    this.vehicle,
    this.planPricing,
    this.city,
    this.refundStatus,
    this.refundAmount,
    this.refundReason,
    this.refundInitiatedAt,
    this.refundCompletedAt,
    this.platformFee,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      id: json['id'] as String? ?? '',
      status: json['status'] as String? ?? '',
      startDate: json['startDate'] as String? ?? json['start_date'] as String?,
      endDate: json['endDate'] as String? ?? json['end_date'] as String?,
      slotType: json['slotType'] as String? ?? json['slot_type'] as String?,
      vehicle: json['vehicle'] != null
          ? VehicleModel.fromJson(json['vehicle'] as Map<String, dynamic>)
          : null,
      planPricing: json['planPricing'] != null
          ? PlanPricingModel.fromJson(json['planPricing'] as Map<String, dynamic>)
          : (json['plan_pricing'] != null
              ? PlanPricingModel.fromJson(json['plan_pricing'] as Map<String, dynamic>)
              : null),
      city: json['city'] != null
          ? CityModel.fromJson(json['city'] as Map<String, dynamic>)
          : null,
      refundStatus: json['refundStatus'] as String? ?? json['refund_status'] as String?,
      refundAmount: json['refundAmount'] as int? ?? json['refund_amount'] as int?,
      refundReason: json['refundReason'] as String? ?? json['refund_reason'] as String?,
      refundInitiatedAt: json['refundInitiatedAt'] as String? ?? json['refund_initiated_at'] as String?,
      refundCompletedAt: json['refundCompletedAt'] as String? ?? json['refund_completed_at'] as String?,
      platformFee: json['platformFee'] as int? ?? json['platform_fee'] as int? ?? 99,
    );
  }
}

class VehicleModel {
  final String id;
  final String brand;
  final String model;
  final String vehicleNumber;
  final String? photoUrl;

  VehicleModel({
    required this.id,
    required this.brand,
    required this.model,
    required this.vehicleNumber,
    this.photoUrl,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id'] as String? ?? '',
      brand: json['brand'] as String? ?? '',
      model: json['model'] as String? ?? '',
      vehicleNumber: json['vehicleNumber'] as String? ?? json['vehicle_number'] as String? ?? '',
      photoUrl: json['photoUrl'] as String? ?? json['photo_url'] as String? ?? json['vehiclePhotoUrl'] as String? ?? json['vehicle_photo_url'] as String? ?? json['imageUrl'] as String? ?? json['image_url'] as String?,
    );
  }
}

class PlanPricingModel {
  final String id;
  final int price;
  final PlanModel? plan;

  PlanPricingModel({
    required this.id,
    required this.price,
    this.plan,
  });

  factory PlanPricingModel.fromJson(Map<String, dynamic> json) {
    return PlanPricingModel(
      id: json['id'] as String? ?? '',
      price: json['price'] as int? ?? 0,
      plan: json['plan'] != null
          ? PlanModel.fromJson(json['plan'] as Map<String, dynamic>)
          : null,
    );
  }
}

class PlanModel {
  final String id;
  final String name;
  final String description;

  PlanModel({
    required this.id,
    required this.name,
    required this.description,
  });

  factory PlanModel.fromJson(Map<String, dynamic> json) {
    return PlanModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }
}

class CityModel {
  final String id;
  final String name;
  final String state;

  CityModel({
    required this.id,
    required this.name,
    required this.state,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      state: json['state'] as String? ?? '',
    );
  }
}

class PaginationMeta {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  PaginationMeta({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 20,
      totalPages: json['totalPages'] as int? ?? json['total_pages'] as int? ?? 1,
    );
  }
}
