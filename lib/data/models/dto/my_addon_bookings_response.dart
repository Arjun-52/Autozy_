class AddonBookingModel {
  final String? id;
  final String? bookingId;
  final String? serviceName;
  final String? serviceCategory;
  final String? bookingDate;
  final String? scheduledDate;
  final String? status;
  final double? amount;
  final String? paymentStatus;
  final String? vehicleDetails;
  final String? createdAt;
  final Map<String, dynamic>? rawJson;

  AddonBookingModel({
    this.id,
    this.bookingId,
    this.serviceName,
    this.serviceCategory,
    this.bookingDate,
    this.scheduledDate,
    this.status,
    this.amount,
    this.paymentStatus,
    this.vehicleDetails,
    this.createdAt,
    this.rawJson,
  });

  factory AddonBookingModel.fromJson(Map<String, dynamic> json) {
    return AddonBookingModel(
      id: json['id']?.toString() ?? json['_id']?.toString(),
      bookingId: json['bookingId']?.toString() ?? json['id']?.toString() ?? json['_id']?.toString(),
      serviceName: json['serviceName']?.toString() ?? json['service']?.toString() ?? json['addonName']?.toString(),
      serviceCategory: json['serviceCategory']?.toString() ?? json['category']?.toString() ?? json['addonCategory']?.toString(),
      bookingDate: json['bookingDate']?.toString() ?? json['date']?.toString() ?? json['bookingDate']?.toString(),
      scheduledDate: json['scheduledDate']?.toString() ?? json['scheduledAt']?.toString() ?? json['date']?.toString(),
      status: json['status']?.toString() ?? json['bookingStatus']?.toString(),
      amount: json['amount'] != null ? double.tryParse(json['amount'].toString()) : null,
      paymentStatus: json['paymentStatus']?.toString() ?? json['payment']?.toString() ?? json['paymentStatus']?.toString(),
      vehicleDetails: json['vehicleDetails']?.toString() ?? json['vehicle']?.toString() ?? json['vehicleNumber']?.toString(),
      createdAt: json['createdAt']?.toString() ?? json['created']?.toString() ?? json['createdAt']?.toString(),
      rawJson: json,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      if (id != null) 'id': id,
      if (bookingId != null) 'bookingId': bookingId,
      if (serviceName != null) 'serviceName': serviceName,
      if (serviceCategory != null) 'serviceCategory': serviceCategory,
      if (bookingDate != null) 'bookingDate': bookingDate,
      if (scheduledDate != null) 'scheduledDate': scheduledDate,
      if (status != null) 'status': status,
      if (amount != null) 'amount': amount,
      if (paymentStatus != null) 'paymentStatus': paymentStatus,
      if (vehicleDetails != null) 'vehicleDetails': vehicleDetails,
      if (createdAt != null) 'createdAt': createdAt,
    };
    if (rawJson != null) {
      map.addAll(rawJson!);
    }
    return map;
  }
}

class AddonBookingPaginationModel {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  AddonBookingPaginationModel({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory AddonBookingPaginationModel.fromJson(Map<String, dynamic> json) {
    return AddonBookingPaginationModel(
      total: json['total'] != null ? int.tryParse(json['total'].toString()) ?? 0 : 0,
      page: json['page'] != null ? int.tryParse(json['page'].toString()) ?? 1 : 1,
      limit: json['limit'] != null ? int.tryParse(json['limit'].toString()) ?? 20 : 20,
      totalPages: json['totalPages'] != null ? int.tryParse(json['totalPages'].toString()) ?? 0 : 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'total': total,
        'page': page,
        'limit': limit,
        'totalPages': totalPages,
      };
}

class MyAddonBookingsResponse {
  final bool success;
  final List<AddonBookingModel> data;
  final AddonBookingPaginationModel? meta;
  final String? timestamp;

  MyAddonBookingsResponse({
    required this.success,
    required this.data,
    this.meta,
    this.timestamp,
  });

  factory MyAddonBookingsResponse.fromJson(Map<String, dynamic> json) {
    final dataList = json['data'] as List?;
    return MyAddonBookingsResponse(
      success: json['success'] as bool? ?? false,
      data: dataList != null
          ? dataList.map((item) => AddonBookingModel.fromJson(item as Map<String, dynamic>)).toList()
          : [],
      meta: json['meta'] != null
          ? AddonBookingPaginationModel.fromJson(json['meta'] as Map<String, dynamic>)
          : null,
      timestamp: json['timestamp']?.toString(),
    );
  }
}
