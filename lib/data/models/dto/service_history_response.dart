class ServiceHistoryModel {
  final String? id;
  final String? vehicleId;
  final String? serviceDate;
  final String? serviceStatus;
  final String? serviceType;
  final String? specialistDetails;
  final String? notes;
  final String? vehicleDetails;
  final String? completionInfo;
  final Map<String, dynamic>? rawJson;

  ServiceHistoryModel({
    this.id,
    this.vehicleId,
    this.serviceDate,
    this.serviceStatus,
    this.serviceType,
    this.specialistDetails,
    this.notes,
    this.vehicleDetails,
    this.completionInfo,
    this.rawJson,
  });

  factory ServiceHistoryModel.fromJson(Map<String, dynamic> json) {
    return ServiceHistoryModel(
      id: json['id']?.toString() ?? json['_id']?.toString(),
      vehicleId: json['vehicleId']?.toString(),
      serviceDate: json['serviceDate']?.toString() ?? json['date']?.toString() ?? json['createdAt']?.toString(),
      serviceStatus: json['serviceStatus']?.toString() ?? json['status']?.toString() ?? json['serviceStatus']?.toString(),
      serviceType: json['serviceType']?.toString() ?? json['type']?.toString() ?? json['serviceType']?.toString(),
      specialistDetails: json['specialistDetails']?.toString() ?? json['specialist']?.toString() ?? json['specialistDetails']?.toString(),
      notes: json['notes']?.toString(),
      vehicleDetails: json['vehicleDetails']?.toString() ?? json['vehicle']?.toString() ?? json['vehicleDetails']?.toString(),
      completionInfo: json['completionInfo']?.toString() ?? json['completedAt']?.toString() ?? json['completionInfo']?.toString(),
      rawJson: json,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      if (id != null) 'id': id,
      if (vehicleId != null) 'vehicleId': vehicleId,
      if (serviceDate != null) 'serviceDate': serviceDate,
      if (serviceStatus != null) 'serviceStatus': serviceStatus,
      if (serviceType != null) 'serviceType': serviceType,
      if (specialistDetails != null) 'specialistDetails': specialistDetails,
      if (notes != null) 'notes': notes,
      if (vehicleDetails != null) 'vehicleDetails': vehicleDetails,
      if (completionInfo != null) 'completionInfo': completionInfo,
    };
    if (rawJson != null) {
      map.addAll(rawJson!);
    }
    return map;
  }
}

class ServiceHistoryMetaModel {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  ServiceHistoryMetaModel({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory ServiceHistoryMetaModel.fromJson(Map<String, dynamic> json) {
    return ServiceHistoryMetaModel(
      total: json['total'] != null ? int.tryParse(json['total'].toString()) ?? 0 : 0,
      page: json['page'] != null ? int.tryParse(json['page'].toString()) ?? 1 : 1,
      limit: json['limit'] != null ? int.tryParse(json['limit'].toString()) ?? 10 : 10,
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

class ServiceHistoryResponse {
  final bool success;
  final List<ServiceHistoryModel> data;
  final ServiceHistoryMetaModel? meta;
  final String? timestamp;

  ServiceHistoryResponse({
    required this.success,
    required this.data,
    this.meta,
    this.timestamp,
  });

  factory ServiceHistoryResponse.fromJson(Map<String, dynamic> json) {
    final dataList = json['data'] as List?;
    return ServiceHistoryResponse(
      success: json['success'] as bool? ?? false,
      data: dataList != null
          ? dataList.map((item) => ServiceHistoryModel.fromJson(item as Map<String, dynamic>)).toList()
          : [],
      meta: json['meta'] != null
          ? ServiceHistoryMetaModel.fromJson(json['meta'] as Map<String, dynamic>)
          : null,
      timestamp: json['timestamp']?.toString(),
    );
  }
}

class PaginatedServiceHistoryModel {
  final List<ServiceHistoryModel> data;
  final ServiceHistoryMetaModel meta;

  PaginatedServiceHistoryModel({
    required this.data,
    required this.meta,
  });
}
