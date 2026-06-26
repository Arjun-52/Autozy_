import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/utils/responsive.dart';

import '../../providers/notification_provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationProvider>().refreshNotifications();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<NotificationProvider>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Notifications",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: context.sp(18)),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, provider, _) {
          if (provider.isListLoading && provider.notifications.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.listError != null && provider.notifications.isEmpty) {
            return _ErrorState(
              message: provider.listError!,
              onRetry: provider.refreshNotifications,
            );
          }

          if (provider.notifications.isEmpty) {
            return RefreshIndicator(
              onRefresh: provider.refreshNotifications,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(height: context.h(160)),
                  const _EmptyState(),
                ],
              ),
            );
          }

          final items = provider.notifications;
          return RefreshIndicator(
            onRefresh: provider.refreshNotifications,
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(context.w(16)),
              itemCount: items.length + (provider.isPageLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= items.length) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: context.h(16)),
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }

                final n = items[index];
                return _notificationCard(
                  context,
                  icon: _iconForType(n.type),
                  title: n.title.isEmpty ? 'Notification' : n.title,
                  subtitle: n.body,
                  time: _timeAgo(n.createdAt),
                  isUnread: !n.isRead,
                  onTap: n.isRead ? null : () => provider.markAsRead(n.id),
                );
              },
            ),
          );
        },
      ),
    );
  }

  IconData _iconForType(String? type) {
    switch (type?.toUpperCase()) {
      case 'BOOKING':
      case 'JOB':
        return Icons.work_outline;
      case 'COMPLETED':
      case 'SUCCESS':
        return Icons.check_circle_outline;
      case 'INSPECTION':
        return Icons.error_outline;
      case 'PAYMENT':
      case 'PAYMENT_CREDITED':
        return Icons.payment;
      default:
        return Icons.notifications_none;
    }
  }

  String _timeAgo(DateTime? time) {
    if (time == null) return '';
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) {
      return '${diff.inHours} hr${diff.inHours == 1 ? '' : 's'} ago';
    }
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    return '${time.day}/${time.month}/${time.year}';
  }

  Widget _notificationCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
    bool isUnread = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE9E9E9), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.015),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3D6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.orange, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: context.sp(13),
                    ),
                  ),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(color: Colors.grey, fontSize: context.sp(11), fontWeight: FontWeight.w400),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  time,
                  style: TextStyle(fontSize: context.sp(10), color: Colors.grey),
                ),
                const SizedBox(height: 4),
                if (isUnread)
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFFC68A00),
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.notifications_off_outlined, size: context.w(56), color: Colors.grey),
          SizedBox(height: context.h(12)),
          Text(
            "You're all caught up",
            style: TextStyle(color: Colors.grey, fontSize: context.sp(14), fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.w(24)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off, size: context.w(56), color: Colors.grey),
            SizedBox(height: context.h(12)),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: context.sp(13), fontWeight: FontWeight.w400),
            ),
            SizedBox(height: context.h(16)),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
