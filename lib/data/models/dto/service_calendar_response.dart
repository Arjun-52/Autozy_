class ServiceCalendarDayModel {
  final String? status;
  final String? time;
  final String? specialist;
  final String? serviceType;
  final String? notes;
  final Map<String, dynamic>? rawJson;

  ServiceCalendarDayModel({
    this.status,
    this.time,
    this.specialist,
    this.serviceType,
    this.notes,
    this.rawJson,
  });

  factory ServiceCalendarDayModel.fromJson(Map<String, dynamic> json) {
    return ServiceCalendarDayModel(
      status: json['status']?.toString() ?? json['serviceStatus']?.toString(),
      time: json['time']?.toString() ?? json['scheduledTime']?.toString(),
      specialist: json['specialist']?.toString() ?? json['specialistDetails']?.toString(),
      serviceType: json['serviceType']?.toString() ?? json['type']?.toString() ?? json['serviceType']?.toString(),
      notes: json['notes']?.toString(),
      rawJson: json,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      if (status != null) 'status': status,
      if (time != null) 'time': time,
      if (specialist != null) 'specialist': specialist,
      if (serviceType != null) 'serviceType': serviceType,
      if (notes != null) 'notes': notes,
    };
    if (rawJson != null) {
      map.addAll(rawJson!);
    }
    return map;
  }
}

class ServiceCalendarModel {
  final int year;
  final int month;
  final Map<String, ServiceCalendarDayModel> days;

  ServiceCalendarModel({
    required this.year,
    required this.month,
    required this.days,
  });

  factory ServiceCalendarModel.fromJson(Map<String, dynamic> json) {
    final daysMap = <String, ServiceCalendarDayModel>{};
    if (json['days'] is Map) {
      final jsonDays = json['days'] as Map<String, dynamic>;
      jsonDays.forEach((key, value) {
        if (value is Map) {
          daysMap[key] = ServiceCalendarDayModel.fromJson(Map<String, dynamic>.from(value));
        }
      });
    }
    return ServiceCalendarModel(
      year: int.tryParse(json['year']?.toString() ?? '') ?? DateTime.now().year,
      month: int.tryParse(json['month']?.toString() ?? '') ?? DateTime.now().month,
      days: daysMap,
    );
  }

  Map<String, dynamic> toJson() => {
        'year': year,
        'month': month,
        'days': days.map((key, value) => MapEntry(key, value.toJson())),
      };
}

class ServiceCalendarResponse {
  final bool success;
  final ServiceCalendarModel? data;
  final String? timestamp;

  ServiceCalendarResponse({
    required this.success,
    this.data,
    this.timestamp,
  });

  factory ServiceCalendarResponse.fromJson(Map<String, dynamic> json) {
    return ServiceCalendarResponse(
      success: json['success'] as bool? ?? false,
      data: json['data'] != null ? ServiceCalendarModel.fromJson(json['data'] as Map<String, dynamic>) : null,
      timestamp: json['timestamp']?.toString(),
    );
  }
}
