class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String? type;
  final bool isRead;
  final DateTime? createdAt;
  final Map<String, dynamic>? data;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    this.type,
    this.isRead = false,
    this.createdAt,
    this.data,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    // The backend does not pin down the response shape, so parse defensively.
    final readValue = json['isRead'] ?? json['read'] ?? json['readAt'];
    final createdRaw = json['createdAt'] ?? json['created_at'] ?? json['timestamp'];

    return NotificationModel(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      body: (json['body'] ?? json['message'] ?? json['description'] ?? '').toString(),
      type: json['type']?.toString(),
      isRead: readValue is bool ? readValue : readValue != null,
      createdAt: createdRaw != null ? DateTime.tryParse(createdRaw.toString()) : null,
      data: json['data'] is Map<String, dynamic> ? json['data'] as Map<String, dynamic> : null,
    );
  }

  NotificationModel copyWith({bool? isRead}) {
    return NotificationModel(
      id: id,
      title: title,
      body: body,
      type: type,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt,
      data: data,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'type': type,
        'isRead': isRead,
        'createdAt': createdAt?.toIso8601String(),
        'data': data,
      };
}
