class AddonSlotsResponseModel {
  final String date;
  final String serviceName;
  final List<AddonSlotModel> slots;

  AddonSlotsResponseModel({
    required this.date,
    required this.serviceName,
    required this.slots,
  });

  factory AddonSlotsResponseModel.fromJson(Map<String, dynamic> json) {
    final slotsList = json['slots'] as List?;
    return AddonSlotsResponseModel(
      date: json['date']?.toString() ?? '',
      serviceName: json['serviceName']?.toString() ?? json['service_name']?.toString() ?? '',
      slots: slotsList != null
          ? slotsList.map((item) => AddonSlotModel.fromJson(item as Map<String, dynamic>)).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'serviceName': serviceName,
      'slots': slots.map((s) => s.toJson()).toList(),
    };
  }
}

class AddonSlotModel {
  final String start;
  final String end;
  final String status;

  AddonSlotModel({
    required this.start,
    required this.end,
    required this.status,
  });

  factory AddonSlotModel.fromJson(Map<String, dynamic> json) {
    return AddonSlotModel(
      start: json['start']?.toString() ?? '',
      end: json['end']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'start': start,
      'end': end,
      'status': status,
    };
  }
}
