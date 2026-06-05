class TicketModel {
  final String? id;
  final String? subscriptionId;
  final String? vehicleId;
  final String? type;
  final String? subject;
  final String? serviceDate;
  final String? description;
  final String? status;
  final String? priority;
  final List<String>? proofPhotos;
  final String? createdAt;
  final String? updatedAt;

  TicketModel({
    this.id,
    this.subscriptionId,
    this.vehicleId,
    this.type,
    this.subject,
    this.serviceDate,
    this.description,
    this.status,
    this.priority,
    this.proofPhotos,
    this.createdAt,
    this.updatedAt,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    List<String> photos = [];
    if (json['proofPhotos'] != null && json['proofPhotos'] is List) {
      photos = (json['proofPhotos'] as List).map((e) => e.toString()).toList();
    }
    return TicketModel(
      id: json['id']?.toString() ?? json['_id']?.toString(),
      subscriptionId: json['subscriptionId']?.toString(),
      vehicleId: json['vehicleId']?.toString(),
      type: json['type']?.toString(),
      subject: json['subject']?.toString() ?? json['type']?.toString() ?? 'Support Ticket',
      serviceDate: json['serviceDate']?.toString(),
      description: json['description']?.toString(),
      status: json['status']?.toString(),
      priority: json['priority']?.toString() ?? 'NORMAL',
      proofPhotos: photos,
      createdAt: json['createdAt']?.toString() ?? json['created_at']?.toString(),
      updatedAt: json['updatedAt']?.toString() ?? json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'subscriptionId': subscriptionId,
        'vehicleId': vehicleId,
        'type': type,
        'subject': subject,
        'serviceDate': serviceDate,
        'description': description,
        'status': status,
        'priority': priority,
        'proofPhotos': proofPhotos,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}

class TicketsPaginationModel {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  TicketsPaginationModel({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory TicketsPaginationModel.fromJson(Map<String, dynamic> json) {
    return TicketsPaginationModel(
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

class TicketsResponseModel {
  final bool success;
  final List<TicketModel> data;
  final TicketsPaginationModel? meta;
  final String? timestamp;

  TicketsResponseModel({
    required this.success,
    required this.data,
    this.meta,
    this.timestamp,
  });

  factory TicketsResponseModel.fromJson(Map<String, dynamic> json) {
    final dataList = json['data'] as List?;
    return TicketsResponseModel(
      success: json['success'] as bool? ?? false,
      data: dataList != null
          ? dataList.map((item) => TicketModel.fromJson(item as Map<String, dynamic>)).toList()
          : [],
      meta: json['meta'] != null
          ? TicketsPaginationModel.fromJson(json['meta'] as Map<String, dynamic>)
          : null,
      timestamp: json['timestamp']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'data': data.map((item) => item.toJson()).toList(),
        'meta': meta?.toJson(),
        'timestamp': timestamp,
      };
}
