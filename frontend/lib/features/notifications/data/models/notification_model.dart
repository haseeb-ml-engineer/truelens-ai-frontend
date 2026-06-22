/// Notification type categories.
enum NotificationType { scanComplete, security, update, promotion }

/// Data model for an in-app notification.
class NotificationModel {
  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final DateTime createdAt;
  final bool isRead;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.createdAt,
    this.isRead = false,
  });

  NotificationModel copyWith({bool? isRead}) {
    return NotificationModel(
      id: id,
      title: title,
      body: body,
      type: type,
      createdAt: createdAt,
      isRead: isRead ?? this.isRead,
    );
  }

  /// Creates a list of mock notifications for development.
  static List<NotificationModel> mockList() {
    return [
      NotificationModel(
        id: 'notif_001',
        title: 'Scan Complete',
        body: 'Your analysis of "profile_photo.jpg" is ready. High risk detected.',
        type: NotificationType.scanComplete,
        createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
      ),
      NotificationModel(
        id: 'notif_002',
        title: 'Security Alert',
        body: 'We detected unusual activity on your account. Please review your settings.',
        type: NotificationType.security,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      NotificationModel(
        id: 'notif_003',
        title: 'New Feature Available',
        body: 'Video analysis now supports 4K resolution. Try it out!',
        type: NotificationType.update,
        createdAt: DateTime.now().subtract(const Duration(hours: 8)),
        isRead: true,
      ),
      NotificationModel(
        id: 'notif_004',
        title: 'Upgrade to Pro',
        body: 'Get unlimited scans, priority processing, and detailed PDF reports.',
        type: NotificationType.promotion,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        isRead: true,
      ),
      NotificationModel(
        id: 'notif_005',
        title: 'Scan Complete',
        body: 'Your analysis of "meeting_recording.mp4" is ready. Low risk detected.',
        type: NotificationType.scanComplete,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        isRead: true,
      ),
    ];
  }
}