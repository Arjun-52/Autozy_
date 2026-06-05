import '../../core/utils/app_logger.dart';
import '../services/api_service.dart';
import '../models/dto/notification_list_response.dart';

class NotificationRepository {
  final ApiService _apiService;

  NotificationRepository(this._apiService);

  static const String _basePath = '/api/v1/notifications';

  Future<NotificationListResponse> getNotifications({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      AppLogger.info('Fetching notifications (page: $page, limit: $limit)', tag: 'Notifications');
      final data = await _apiService.get(
        _basePath,
        queryParameters: {'page': page.toString(), 'limit': limit.toString()},
      );
      return NotificationListResponse.fromJson(data);
    } catch (e, st) {
      AppLogger.error('Failed to fetch notifications', tag: 'Notifications', error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<int> getUnreadCount() async {
    try {
      final data = await _apiService.get('$_basePath/unread-count');
      // Tolerate { data: { count } }, { data: N }, or { count }.
      final node = data['data'] ?? data;
      final dynamic count = node is Map
          ? (node['count'] ?? node['unread'] ?? node['unreadCount'])
          : node;
      return int.tryParse(count?.toString() ?? '0') ?? 0;
    } catch (e, st) {
      AppLogger.error('Failed to fetch unread count', tag: 'Notifications', error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<bool> markAsRead(String notificationId) async {
    try {
      AppLogger.info('Marking notification as read: $notificationId', tag: 'Notifications');
      final data = await _apiService.patch('$_basePath/$notificationId/read');
      return data['success'] as bool? ?? true;
    } catch (e, st) {
      AppLogger.error('Failed to mark notification as read: $notificationId', tag: 'Notifications', error: e, stackTrace: st);
      rethrow;
    }
  }
}
