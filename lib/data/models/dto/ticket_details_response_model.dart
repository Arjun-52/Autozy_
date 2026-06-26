class TicketAuthorModel {
  final String? id;
  final String? name;
  final String? email;
  final String? role;
  final String? avatar;

  TicketAuthorModel({
    this.id,
    this.name,
    this.email,
    this.role,
    this.avatar,
  });

  factory TicketAuthorModel.fromJson(Map<String, dynamic> json) {
    return TicketAuthorModel(
      id: json['id']?.toString() ?? json['_id']?.toString(),
      name: json['name']?.toString(),
      email: json['email']?.toString(),
      role: json['role']?.toString(),
      avatar: json['avatar']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'role': role,
        'avatar': avatar,
      };
}

class TicketReplyModel {
  final String? id;
  final String? message;
  final String? attachment;
  final List<String>? attachments;
  final String? authorName;
  final String? authorRole;
  final String? createdAt;
  final bool isAgent;

  TicketReplyModel({
    this.id,
    this.message,
    this.attachment,
    this.attachments,
    this.authorName,
    this.authorRole,
    this.createdAt,
    this.isAgent = false,
  });

  factory TicketReplyModel.fromJson(Map<String, dynamic> json) {
    List<String> list = [];
    if (json['attachments'] is List) {
      list = (json['attachments'] as List).map((e) => e.toString()).toList();
    }
    return TicketReplyModel(
      id: json['id']?.toString() ?? json['_id']?.toString(),
      message: json['message']?.toString() ?? json['text']?.toString(),
      attachment: json['attachment']?.toString(),
      attachments: list,
      authorName: json['authorName']?.toString() ?? json['author']?['name']?.toString(),
      authorRole: json['authorRole']?.toString() ?? json['author']?['role']?.toString(),
      createdAt: json['createdAt']?.toString() ?? json['created_at']?.toString(),
      isAgent: json['isAgent'] as bool? ?? json['is_agent'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'message': message,
        'attachment': attachment,
        'attachments': attachments,
        'authorName': authorName,
        'authorRole': authorRole,
        'createdAt': createdAt,
        'isAgent': isAgent,
      };
}

class TicketDetailsModel {
  final String? id;
  final String? subject;
  final String? type;
  final String? priority;
  final String? status;
  final String? description;
  final String? attachment;
  final List<String>? attachments;
  final String? createdAt;
  final String? updatedAt;
  final TicketAuthorModel? author;
  final List<TicketReplyModel> replies;
  final String? vehicleId;
  final String? vehicleNumber;
  final String? subscriptionId;
  final String? serviceDate;

  TicketDetailsModel({
    this.id,
    this.subject,
    this.type,
    this.priority,
    this.status,
    this.description,
    this.attachment,
    this.attachments,
    this.createdAt,
    this.updatedAt,
    this.author,
    this.replies = const [],
    this.vehicleId,
    this.vehicleNumber,
    this.subscriptionId,
    this.serviceDate,
  });

  factory TicketDetailsModel.fromJson(Map<String, dynamic> json) {
    List<String> list = [];
    if (json['attachments'] is List) {
      list = (json['attachments'] as List).map((e) => e.toString()).toList();
    } else if (json['proofPhotos'] is List) {
      list = (json['proofPhotos'] as List).map((e) => e.toString()).toList();
    }

    final repliesJson = json['replies'] as List?;
    final repliesList = repliesJson != null
        ? repliesJson.map((e) => TicketReplyModel.fromJson(e as Map<String, dynamic>)).toList()
        : <TicketReplyModel>[];

    return TicketDetailsModel(
      id: json['id']?.toString() ?? json['_id']?.toString(),
      subject: json['subject']?.toString() ?? json['type']?.toString() ?? 'Support Ticket',
      type: json['type']?.toString(),
      priority: json['priority']?.toString() ?? 'NORMAL',
      status: json['status']?.toString() ?? 'OPEN',
      description: json['description']?.toString(),
      attachment: json['attachment']?.toString(),
      attachments: list,
      createdAt: json['createdAt']?.toString() ?? json['created_at']?.toString(),
      updatedAt: json['updatedAt']?.toString() ?? json['updated_at']?.toString(),
      author: json['author'] != null ? TicketAuthorModel.fromJson(json['author']) : null,
      replies: repliesList,
      vehicleId: json['vehicleId']?.toString(),
      vehicleNumber: json['vehicleNumber']?.toString() ?? json['vehicle']?['vehicleNumber']?.toString(),
      subscriptionId: json['subscriptionId']?.toString(),
      serviceDate: json['serviceDate']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'subject': subject,
        'type': type,
        'priority': priority,
        'status': status,
        'description': description,
        'attachment': attachment,
        'attachments': attachments,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'author': author?.toJson(),
        'replies': replies.map((e) => e.toJson()).toList(),
        'vehicleId': vehicleId,
        'vehicleNumber': vehicleNumber,
        'subscriptionId': subscriptionId,
        'serviceDate': serviceDate,
      };
}

class TicketDetailsResponseModel {
  final bool success;
  final TicketDetailsModel? data;
  final String? timestamp;

  TicketDetailsResponseModel({
    required this.success,
    this.data,
    this.timestamp,
  });

  factory TicketDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    return TicketDetailsResponseModel(
      success: json['success'] as bool? ?? false,
      data: json['data'] != null ? TicketDetailsModel.fromJson(json['data']) : null,
      timestamp: json['timestamp']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'data': data?.toJson(),
        'timestamp': timestamp,
      };
}
