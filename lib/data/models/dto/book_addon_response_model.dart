class BookAddonResponseModel {
  final String? id;
  final String? userId;
  final String? vehicleId;
  final String? addonServiceId;
  final String? scheduledDate;
  final String? scheduledSlotStart;
  final String? scheduledSlotEnd;
  final String? status;
  final String? specialistId;
  final String? assignedAt;
  final String? price;

  BookAddonResponseModel({
    this.id,
    this.userId,
    this.vehicleId,
    this.addonServiceId,
    this.scheduledDate,
    this.scheduledSlotStart,
    this.scheduledSlotEnd,
    this.status,
    this.specialistId,
    this.assignedAt,
    this.price,
  });

  factory BookAddonResponseModel.fromJson(Map<String, dynamic> json) {
    return BookAddonResponseModel(
      id: json['id']?.toString(),
      userId: json['user_id']?.toString() ?? json['userId']?.toString(),
      vehicleId: json['vehicle_id']?.toString() ?? json['vehicleId']?.toString(),
      addonServiceId: json['addon_service_id']?.toString() ?? json['addonServiceId']?.toString(),
      scheduledDate: json['scheduled_date']?.toString() ?? json['scheduledDate']?.toString(),
      scheduledSlotStart: json['scheduled_slot_start']?.toString() ?? json['scheduledSlotStart']?.toString(),
      scheduledSlotEnd: json['scheduled_slot_end']?.toString() ?? json['scheduledSlotEnd']?.toString(),
      status: json['status']?.toString(),
      specialistId: json['specialist_id']?.toString() ?? json['specialistId']?.toString(),
      assignedAt: json['assigned_at']?.toString() ?? json['assignedAt']?.toString(),
      price: json['price']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'vehicle_id': vehicleId,
        'addon_service_id': addonServiceId,
        'scheduled_date': scheduledDate,
        'scheduled_slot_start': scheduledSlotStart,
        'scheduled_slot_end': scheduledSlotEnd,
        'status': status,
        'specialist_id': specialistId,
        'assigned_at': assignedAt,
        'price': price,
      };
}

