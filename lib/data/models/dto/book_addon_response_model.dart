class BookedAddonDataModel {
  final String? userId;
  final String? vehicleId;
  final String? addonServiceId;
  final String? specialistId;
  final String? scheduledDate;
  final String? scheduledSlotStart;
  final String? scheduledSlotEnd;
  final String? status;
  final String? disputeWindowEnd;
  final String? id;
  final String? supervisorAuditStatus;
  final String? createdAt;
  final String? updatedAt;

  BookedAddonDataModel({
    this.userId,
    this.vehicleId,
    this.addonServiceId,
    this.specialistId,
    this.scheduledDate,
    this.scheduledSlotStart,
    this.scheduledSlotEnd,
    this.status,
    this.disputeWindowEnd,
    this.id,
    this.supervisorAuditStatus,
    this.createdAt,
    this.updatedAt,
  });

  factory BookedAddonDataModel.fromJson(Map<String, dynamic> json) {
    return BookedAddonDataModel(
      userId: json['user_id']?.toString() ?? json['userId']?.toString(),
      vehicleId: json['vehicle_id']?.toString() ?? json['vehicleId']?.toString(),
      addonServiceId: json['addon_service_id']?.toString() ?? json['addonServiceId']?.toString(),
      specialistId: json['specialist_id']?.toString() ?? json['specialistId']?.toString(),
      scheduledDate: json['scheduled_date']?.toString() ?? json['scheduledDate']?.toString(),
      scheduledSlotStart: json['scheduled_slot_start']?.toString() ?? json['scheduledSlotStart']?.toString(),
      scheduledSlotEnd: json['scheduled_slot_end']?.toString() ?? json['scheduledSlotEnd']?.toString(),
      status: json['status']?.toString(),
      disputeWindowEnd: json['dispute_window_end']?.toString() ?? json['disputeWindowEnd']?.toString(),
      id: json['id']?.toString() ?? json['_id']?.toString(),
      supervisorAuditStatus: json['supervisor_audit_status']?.toString() ?? json['supervisorAuditStatus']?.toString(),
      createdAt: json['created_at']?.toString() ?? json['createdAt']?.toString(),
      updatedAt: json['updated_at']?.toString() ?? json['updatedAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'vehicle_id': vehicleId,
        'addon_service_id': addonServiceId,
        'specialist_id': specialistId,
        'scheduled_date': scheduledDate,
        'scheduled_slot_start': scheduledSlotStart,
        'scheduled_slot_end': scheduledSlotEnd,
        'status': status,
        'dispute_window_end': disputeWindowEnd,
        'id': id,
        'supervisor_audit_status': supervisorAuditStatus,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}

class BookAddonResponseModel {
  final bool success;
  final BookedAddonDataModel? data;
  final String? timestamp;

  BookAddonResponseModel({
    required this.success,
    this.data,
    this.timestamp,
  });

  factory BookAddonResponseModel.fromJson(Map<String, dynamic> json) {
    return BookAddonResponseModel(
      success: json['success'] as bool? ?? false,
      data: json['data'] != null ? BookedAddonDataModel.fromJson(json['data'] as Map<String, dynamic>) : null,
      timestamp: json['timestamp']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'data': data?.toJson(),
        'timestamp': timestamp,
      };
}
