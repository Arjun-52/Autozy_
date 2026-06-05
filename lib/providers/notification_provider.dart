import 'package:flutter/foundation.dart';
import '../../core/utils/app_logger.dart';
import '../data/repositories/notification_repository.dart';
import '../data/models/notification_model.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationRepository _notificationRepository;

  NotificationProvider(this._notificationRepository);

  List<NotificationModel> _notifications = [];
  int _unreadCount = 0;

  // Pagination state (mirrors VehicleProvider conventions)
  int _currentPage = 1;
  int _totalPages = 1;
  bool _isListLoading = false;
  bool _isPageLoading = false;
  String? _listError;

  List<NotificationModel> get notifications => _notifications;
  int get unreadCount => _unreadCount;
  bool get isListLoading => _isListLoading;
  bool get isPageLoading => _isPageLoading;
  String? get listError => _listError;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  bool get hasMore => _currentPage < _totalPages;

  Future<void> fetchNotifications({
    int page = 1,
    int limit = 20,
    bool reset = false,
  }) async {
    if (reset) {
      _notifications = [];
      _currentPage = 1;
      _totalPages = 1;
    }

    if (page == 1) {
      _isListLoading = true;
    } else {
      _isPageLoading = true;
    }
    _listError = null;
    notifyListeners();

    try {
      final response = await _notificationRepository.getNotifications(page: page, limit: limit);
      final fetched = response.notifications ?? [];
      _currentPage = response.meta?.page ?? page;
      _totalPages = response.meta?.totalPages ?? 1;

      if (page == 1) {
        _notifications = fetched;
      } else {
        _notifications.addAll(fetched);
      }
      // Keep the badge in sync with what we just loaded.
      _unreadCount = _notifications.where((n) => !n.isRead).length;
    } catch (e) {
      _listError = e.toString().replaceAll('Exception: ', '');
    } finally {
      if (page == 1) {
        _isListLoading = false;
      } else {
        _isPageLoading = false;
      }
      notifyListeners();
    }
  }

  Future<void> refreshNotifications({int limit = 20}) async {
    await fetchNotifications(page: 1, limit: limit, reset: true);
  }

  Future<void> loadMore({int limit = 20}) async {
    if (!hasMore || _isPageLoading) return;
    await fetchNotifications(page: _currentPage + 1, limit: limit);
  }

  Future<void> fetchUnreadCount() async {
    try {
      _unreadCount = await _notificationRepository.getUnreadCount();
      notifyListeners();
    } catch (e) {
      AppLogger.error('Unable to refresh unread count', tag: 'Notifications', error: e);
    }
  }

  Future<bool> markAsRead(String notificationId) async {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index == -1 || _notifications[index].isRead) return true;

    // Optimistic update.
    final previous = _notifications[index];
    _notifications[index] = previous.copyWith(isRead: true);
    if (_unreadCount > 0) _unreadCount--;
    notifyListeners();

    try {
      final ok = await _notificationRepository.markAsRead(notificationId);
      if (!ok) throw Exception('Mark as read rejected by server');
      return true;
    } catch (e) {
      // Roll back on failure.
      _notifications[index] = previous;
      _unreadCount++;
      notifyListeners();
      AppLogger.error('Failed to mark as read, rolled back', tag: 'Notifications', error: e);
      return false;
    }
  }
}
