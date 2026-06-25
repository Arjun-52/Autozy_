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

  SubscriptionModel({
    required this.id,
    required this.status,
    this.startDate,
    this.endDate,
    this.slotType,
    this.vehicle,
    this.planPricing,
    this.city,
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
    );
  }
}

class VehicleModel {
  final String id;
  final String brand;
  final String model;
  final String vehicleNumber;

  VehicleModel({
    required this.id,
    required this.brand,
    required this.model,
    required this.vehicleNumber,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id'] as String? ?? '',
      brand: json['brand'] as String? ?? '',
      model: json['model'] as String? ?? '',
      vehicleNumber: json['vehicleNumber'] as String? ?? json['vehicle_number'] as String? ?? '',
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
      price: json['price'] as int? ?? json['price_monthly'] as int? ?? 0,
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
