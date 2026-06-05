import '../notification_model.dart';
import 'pagination_meta.dart';

class NotificationListResponse {
  final bool? success;
  final List<NotificationModel>? notifications;
  final PaginationMeta? meta;
  final String? timestamp;

  NotificationListResponse({
    this.success,
    this.notifications,
    this.meta,
    this.timestamp,
  });

  factory NotificationListResponse.fromJson(Map<String, dynamic> json) {
    // `data` may be the list directly, or wrapped under `data.items` / `notifications`.
    final dynamic dataNode = json['data'];
    dynamic listJson = dataNode is List
        ? dataNode
        : (dataNode is Map ? (dataNode['items'] ?? dataNode['notifications']) : null);
    listJson ??= json['notifications'] ?? [];

    final meta = json['meta'] ??
        (dataNode is Map ? dataNode['meta'] : null);

    List<NotificationModel> list = [];
    if (listJson is List) {
      list = listJson
          .whereType<Map<String, dynamic>>()
          .map((e) => NotificationModel.fromJson(e))
          .toList();
    }

    return NotificationListResponse(
      success: json['success'] as bool?,
      notifications: list,
      meta: meta is Map<String, dynamic> ? PaginationMeta.fromJson(meta) : null,
      timestamp: json['timestamp'] as String?,
    );
  }
}
