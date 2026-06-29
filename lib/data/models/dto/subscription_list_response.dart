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
  final String? userId;
  final String? vehicleId;
  final String? planPricingId;
  final String? areaId;
  final String? startDate;
  final String? endDate;
  final String? slotType;
  final String? inspectionDeadline;
  final String? serviceStartDate;
  final bool? autoRenew;
  final String? pauseReason;
  final String? pauseNotes;
  final String? createdAt;
  final String? updatedAt;
  final String? paymentStatus;
  final VehicleModel? vehicle;
  final PlanPricingModel? planPricing;
  final CityModel? city;
  final SubscriptionUserModel? user;
  final List<SubscriptionPaymentModel>? payments;
  final List<SubscriptionServiceRecordModel>? serviceRecords;
  final List<ServicesSummaryModel>? servicesSummary;

  SubscriptionModel({
    required this.id,
    required this.status,
    this.userId,
    this.vehicleId,
    this.planPricingId,
    this.areaId,
    this.startDate,
    this.endDate,
    this.slotType,
    this.inspectionDeadline,
    this.serviceStartDate,
    this.autoRenew,
    this.pauseReason,
    this.pauseNotes,
    this.createdAt,
    this.updatedAt,
    this.paymentStatus,
    this.vehicle,
    this.planPricing,
    this.city,
    this.user,
    this.payments,
    this.serviceRecords,
    this.servicesSummary,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      id: json['id'] as String? ?? '',
      status: json['status'] as String? ?? '',
      userId: json['user_id'] as String? ?? json['userId'] as String?,
      vehicleId: json['vehicle_id'] as String? ?? json['vehicleId'] as String?,
      planPricingId: json['plan_pricing_id'] as String? ?? json['planPricingId'] as String?,
      areaId: json['area_id'] as String? ?? json['areaId'] as String?,
      startDate: json['startDate'] as String? ?? json['start_date'] as String?,
      endDate: json['endDate'] as String? ?? json['end_date'] as String?,
      slotType: json['slotType'] as String? ?? json['slot_type'] as String?,
      inspectionDeadline: json['inspection_deadline'] as String? ?? json['inspectionDeadline'] as String?,
      serviceStartDate: json['service_start_date'] as String? ?? json['serviceStartDate'] as String?,
      autoRenew: json['auto_renew'] as bool? ?? json['autoRenew'] as bool?,
      pauseReason: json['pause_reason'] as String? ?? json['pauseReason'] as String?,
      pauseNotes: json['pause_notes'] as String? ?? json['pauseNotes'] as String?,
      createdAt: json['created_at'] as String? ?? json['createdAt'] as String?,
      updatedAt: json['updated_at'] as String? ?? json['updatedAt'] as String?,
      paymentStatus: json['paymentStatus'] as String? ?? json['payment_status'] as String?,
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
      user: json['user'] != null
          ? SubscriptionUserModel.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      payments: json['payments'] != null
          ? (json['payments'] as List)
              .map((item) => SubscriptionPaymentModel.fromJson(item as Map<String, dynamic>))
              .toList()
          : null,
      serviceRecords: json['service_records'] != null
          ? (json['service_records'] as List)
              .map((item) => SubscriptionServiceRecordModel.fromJson(item as Map<String, dynamic>))
              .toList()
          : (json['serviceRecords'] != null
              ? (json['serviceRecords'] as List)
                  .map((item) => SubscriptionServiceRecordModel.fromJson(item as Map<String, dynamic>))
                  .toList()
              : null),
      servicesSummary: json['services_summary'] != null
          ? (json['services_summary'] as List)
              .map((item) => ServicesSummaryModel.fromJson(item as Map<String, dynamic>))
              .toList()
          : (json['servicesSummary'] != null
              ? (json['servicesSummary'] as List)
                  .map((item) => ServicesSummaryModel.fromJson(item as Map<String, dynamic>))
                  .toList()
              : null),
    );
  }
}

class VehicleModel {
  final String id;
  final String brand;
  final String model;
  final String vehicleNumber;
  final String? userId;
  final String? sizeCategory;
  final String? imageUrl;
  final String? parkingLocationLat;
  final String? parkingLocationLng;
  final String? parkingNotes;
  final String? flatNo;
  final String? building;
  final String? locality;
  final String? landmark;
  final String? city;
  final String? state;
  final String? pincode;
  final bool? parkingLotAvailable;
  final String? pillarNumber;
  final String? keyHandoverType;
  final bool? securityPermissionRequired;
  final String? status;
  final String? rejectionReason;
  final bool? isActive;
  final String? createdAt;

  VehicleModel({
    required this.id,
    required this.brand,
    required this.model,
    required this.vehicleNumber,
    this.userId,
    this.sizeCategory,
    this.imageUrl,
    this.parkingLocationLat,
    this.parkingLocationLng,
    this.parkingNotes,
    this.flatNo,
    this.building,
    this.locality,
    this.landmark,
    this.city,
    this.state,
    this.pincode,
    this.parkingLotAvailable,
    this.pillarNumber,
    this.keyHandoverType,
    this.securityPermissionRequired,
    this.status,
    this.rejectionReason,
    this.isActive,
    this.createdAt,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id'] as String? ?? '',
      brand: json['brand'] as String? ?? '',
      model: json['model'] as String? ?? '',
      vehicleNumber: json['vehicleNumber'] as String? ?? json['vehicle_number'] as String? ?? '',
      userId: json['user_id'] as String? ?? json['userId'] as String?,
      sizeCategory: json['size_category'] as String? ?? json['sizeCategory'] as String?,
      imageUrl: json['image_url'] as String? ?? json['imageUrl'] as String?,
      parkingLocationLat: json['parking_location_lat']?.toString() ?? json['parkingLocationLat']?.toString(),
      parkingLocationLng: json['parking_location_lng']?.toString() ?? json['parkingLocationLng']?.toString(),
      parkingNotes: json['parking_notes'] as String? ?? json['parkingNotes'] as String?,
      flatNo: json['flat_no'] as String? ?? json['flatNo'] as String?,
      building: json['building'] as String?,
      locality: json['locality'] as String?,
      landmark: json['landmark'] as String?,
      city: json['city'] is String ? json['city'] as String? : null,
      state: json['state'] as String?,
      pincode: json['pincode'] as String?,
      parkingLotAvailable: json['parking_lot_available'] as bool? ?? json['parkingLotAvailable'] as bool?,
      pillarNumber: json['pillar_number'] as String? ?? json['pillarNumber'] as String?,
      keyHandoverType: json['key_handover_type'] as String? ?? json['keyHandoverType'] as String?,
      securityPermissionRequired: json['security_permission_required'] as bool? ?? json['securityPermissionRequired'] as bool?,
      status: json['status'] as String?,
      rejectionReason: json['rejection_reason'] as String? ?? json['rejectionReason'] as String?,
      isActive: json['is_active'] as bool? ?? json['isActive'] as bool?,
      createdAt: json['created_at'] as String? ?? json['createdAt'] as String?,
    );
  }
}

class PlanPricingModel {
  final String id;
  final int price;
  final PlanModel? plan;
  final String? planId;
  final String? cityId;
  final String? areaId;
  final String? vehicleSize;
  final int? gstRate;
  final String? effectiveFrom;
  final bool? isActive;
  final String? createdBy;
  final String? createdAt;
  final CityModel? city;
  final dynamic area;

  PlanPricingModel({
    required this.id,
    required this.price,
    this.plan,
    this.planId,
    this.cityId,
    this.areaId,
    this.vehicleSize,
    this.gstRate,
    this.effectiveFrom,
    this.isActive,
    this.createdBy,
    this.createdAt,
    this.city,
    this.area,
  });

  factory PlanPricingModel.fromJson(Map<String, dynamic> json) {
    return PlanPricingModel(
      id: json['id'] as String? ?? '',
      price: json['price'] as int? ?? json['price_monthly'] as int? ?? 0,
      plan: json['plan'] != null
          ? PlanModel.fromJson(json['plan'] as Map<String, dynamic>)
          : null,
      planId: json['plan_id'] as String? ?? json['planId'] as String?,
      cityId: json['city_id'] as String? ?? json['cityId'] as String?,
      areaId: json['area_id'] as String? ?? json['areaId'] as String?,
      vehicleSize: json['vehicle_size'] as String? ?? json['vehicleSize'] as String?,
      gstRate: json['gst_rate'] as int? ?? json['gstRate'] as int?,
      effectiveFrom: json['effective_from'] as String? ?? json['effectiveFrom'] as String?,
      isActive: json['is_active'] as bool? ?? json['isActive'] as bool?,
      createdBy: json['created_by'] as String? ?? json['createdBy'] as String?,
      createdAt: json['created_at'] as String? ?? json['createdAt'] as String?,
      city: json['city'] != null && json['city'] is Map<String, dynamic>
          ? CityModel.fromJson(json['city'] as Map<String, dynamic>)
          : null,
      area: json['area'],
    );
  }
}

class PlanModel {
  final String id;
  final String name;
  final String description;
  final PlanFeaturesModel? features;
  final bool? isActive;
  final String? createdAt;

  PlanModel({
    required this.id,
    required this.name,
    required this.description,
    this.features,
    this.isActive,
    this.createdAt,
  });

  factory PlanModel.fromJson(Map<String, dynamic> json) {
    return PlanModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      features: json['features'] != null && json['features'] is Map<String, dynamic>
          ? PlanFeaturesModel.fromJson(json['features'] as Map<String, dynamic>)
          : null,
      isActive: json['is_active'] as bool? ?? json['isActive'] as bool?,
      createdAt: json['created_at'] as String? ?? json['createdAt'] as String?,
    );
  }
}

class PlanFeaturesModel {
  final List<String>? included;
  final List<String>? excluded;

  PlanFeaturesModel({
    this.included,
    this.excluded,
  });

  factory PlanFeaturesModel.fromJson(Map<String, dynamic> json) {
    return PlanFeaturesModel(
      included: json['included'] != null
          ? (json['included'] as List).map((e) => e.toString()).toList()
          : null,
      excluded: json['excluded'] != null
          ? (json['excluded'] as List).map((e) => e.toString()).toList()
          : null,
    );
  }
}

class CityModel {
  final String id;
  final String name;
  final String state;
  final bool? isActive;
  final String? createdAt;

  CityModel({
    required this.id,
    required this.name,
    required this.state,
    this.isActive,
    this.createdAt,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      state: json['state'] as String? ?? '',
      isActive: json['is_active'] as bool? ?? json['isActive'] as bool?,
      createdAt: json['created_at'] as String? ?? json['createdAt'] as String?,
    );
  }
}

class SubscriptionUserModel {
  final String id;
  final String? phone;
  final String? name;
  final String? email;
  final bool? isActive;
  final String? deviceId;
  final String? lastActiveAt;
  final String? createdAt;
  final String? updatedAt;

  SubscriptionUserModel({
    required this.id,
    this.phone,
    this.name,
    this.email,
    this.isActive,
    this.deviceId,
    this.lastActiveAt,
    this.createdAt,
    this.updatedAt,
  });

  factory SubscriptionUserModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionUserModel(
      id: json['id'] as String? ?? '',
      phone: json['phone'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      isActive: json['is_active'] as bool? ?? json['isActive'] as bool?,
      deviceId: json['device_id'] as String? ?? json['deviceId'] as String?,
      lastActiveAt: json['last_active_at'] as String? ?? json['lastActiveAt'] as String?,
      createdAt: json['created_at'] as String? ?? json['createdAt'] as String?,
      updatedAt: json['updated_at'] as String? ?? json['updatedAt'] as String?,
    );
  }
}

class SubscriptionPaymentModel {
  final String id;
  final String? userId;
  final String? subscriptionId;
  final String? addonBookingId;
  final String? amount;
  final String? currency;
  final String? paymentGateway;
  final String? gatewayPaymentId;
  final String? gatewayOrderId;
  final String? status;
  final String? invoiceNumber;
  final String? gstAmount;
  final String? invoiceUrl;
  final String? refundAmount;
  final String? refundReason;
  final String? refundStatus;
  final String? createdAt;

  SubscriptionPaymentModel({
    required this.id,
    this.userId,
    this.subscriptionId,
    this.addonBookingId,
    this.amount,
    this.currency,
    this.paymentGateway,
    this.gatewayPaymentId,
    this.gatewayOrderId,
    this.status,
    this.invoiceNumber,
    this.gstAmount,
    this.invoiceUrl,
    this.refundAmount,
    this.refundReason,
    this.refundStatus,
    this.createdAt,
  });

  factory SubscriptionPaymentModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionPaymentModel(
      id: json['id'] as String? ?? '',
      userId: json['user_id'] as String? ?? json['userId'] as String?,
      subscriptionId: json['subscription_id'] as String? ?? json['subscriptionId'] as String?,
      addonBookingId: json['addon_booking_id'] as String? ?? json['addonBookingId'] as String?,
      amount: json['amount']?.toString(),
      currency: json['currency'] as String?,
      paymentGateway: json['payment_gateway'] as String? ?? json['paymentGateway'] as String?,
      gatewayPaymentId: json['gateway_payment_id'] as String? ?? json['gatewayPaymentId'] as String?,
      gatewayOrderId: json['gateway_order_id'] as String? ?? json['gatewayOrderId'] as String?,
      status: json['status'] as String?,
      invoiceNumber: json['invoice_number'] as String? ?? json['invoiceNumber'] as String?,
      gstAmount: json['gst_amount']?.toString() ?? json['gstAmount']?.toString(),
      invoiceUrl: json['invoice_url'] as String? ?? json['invoiceUrl'] as String?,
      refundAmount: json['refund_amount']?.toString() ?? json['refundAmount']?.toString(),
      refundReason: json['refund_reason'] as String? ?? json['refundReason'] as String?,
      refundStatus: json['refund_status'] as String? ?? json['refundStatus'] as String?,
      createdAt: json['created_at'] as String? ?? json['createdAt'] as String?,
    );
  }
}

class SubscriptionServiceRecordModel {
  final String id;
  final String? subscriptionId;
  final String? vehicleId;
  final String? detailerId;
  final String? serviceDate;
  final String? serviceType;
  final String? status;
  final dynamic photos;
  final String? gpsLat;
  final String? gpsLng;
  final String? completedAt;
  final String? notes;
  final String? beforeImage;
  final String? beforeImageCapturedAt;
  final String? afterPhotoUrl;
  final String? afterPhotoUploadedAt;
  final String? afterPhotoUploadedBy;
  final String? verificationStatus;
  final String? verifiedBy;
  final String? verifiedAt;
  final String? verificationRejectionReason;
  final String? comments;
  final String? issue;
  final String? remarks;
  final String? createdAt;

  SubscriptionServiceRecordModel({
    required this.id,
    this.subscriptionId,
    this.vehicleId,
    this.detailerId,
    this.serviceDate,
    this.serviceType,
    this.status,
    this.photos,
    this.gpsLat,
    this.gpsLng,
    this.completedAt,
    this.notes,
    this.beforeImage,
    this.beforeImageCapturedAt,
    this.afterPhotoUrl,
    this.afterPhotoUploadedAt,
    this.afterPhotoUploadedBy,
    this.verificationStatus,
    this.verifiedBy,
    this.verifiedAt,
    this.verificationRejectionReason,
    this.comments,
    this.issue,
    this.remarks,
    this.createdAt,
  });

  factory SubscriptionServiceRecordModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionServiceRecordModel(
      id: json['id'] as String? ?? '',
      subscriptionId: json['subscription_id'] as String? ?? json['subscriptionId'] as String?,
      vehicleId: json['vehicle_id'] as String? ?? json['vehicleId'] as String?,
      detailerId: json['detailer_id'] as String? ?? json['detailerId'] as String?,
      serviceDate: json['service_date'] as String? ?? json['serviceDate'] as String?,
      serviceType: json['service_type'] as String? ?? json['serviceType'] as String?,
      status: json['status'] as String?,
      photos: json['photos'],
      gpsLat: json['gps_lat']?.toString() ?? json['gpsLat']?.toString(),
      gpsLng: json['gps_lng']?.toString() ?? json['gpsLng']?.toString(),
      completedAt: json['completed_at'] as String? ?? json['completedAt'] as String?,
      notes: json['notes'] as String?,
      beforeImage: json['before_image'] as String? ?? json['beforeImage'] as String?,
      beforeImageCapturedAt: json['before_image_captured_at'] as String? ?? json['beforeImageCapturedAt'] as String?,
      afterPhotoUrl: json['after_photo_url'] as String? ?? json['afterPhotoUrl'] as String?,
      afterPhotoUploadedAt: json['after_photo_uploaded_at'] as String? ?? json['afterPhotoUploadedAt'] as String?,
      afterPhotoUploadedBy: json['after_photo_uploaded_by'] as String? ?? json['afterPhotoUploadedBy'] as String?,
      verificationStatus: json['verification_status'] as String? ?? json['verificationStatus'] as String?,
      verifiedBy: json['verified_by'] as String? ?? json['verifiedBy'] as String?,
      verifiedAt: json['verified_at'] as String? ?? json['verifiedAt'] as String?,
      verificationRejectionReason: json['verification_rejection_reason'] as String? ?? json['verificationRejectionReason'] as String?,
      comments: json['comments'] as String?,
      issue: json['issue'] as String?,
      remarks: json['remarks'] as String?,
      createdAt: json['created_at'] as String? ?? json['createdAt'] as String?,
    );
  }
}

class ServicesSummaryModel {
  final String? type;
  final int? allowed;
  final int? used;
  final int? remaining;
  final List<dynamic>? history;

  ServicesSummaryModel({
    this.type,
    this.allowed,
    this.used,
    this.remaining,
    this.history,
  });

  factory ServicesSummaryModel.fromJson(Map<String, dynamic> json) {
    return ServicesSummaryModel(
      type: json['type'] as String?,
      allowed: json['allowed'] as int?,
      used: json['used'] as int?,
      remaining: json['remaining'] as int?,
      history: json['history'] as List<dynamic>?,
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
