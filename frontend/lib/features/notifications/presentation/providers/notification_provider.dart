import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:deepshield_ai/features/notifications/data/models/notification_model.dart';

/// State class for the notifications.
class NotificationState {
  final List<NotificationModel> notifications;
  final bool isLoading;

  const NotificationState({
    this.notifications = const [],
    this.isLoading = false,
  });

  NotificationState copyWith({
    List<NotificationModel>? notifications,
    bool? isLoading,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// StateNotifier to manage notification operations.
class NotificationNotifier extends StateNotifier<NotificationState> {
  NotificationNotifier() : super(const NotificationState()) {
    _loadNotifications();
  }

  void _loadNotifications() {
    state = state.copyWith(isLoading: true);
    final mockData = NotificationModel.mockList();
    state = state.copyWith(notifications: mockData, isLoading: false);
  }

  /// Mark a single notification as read.
  void markAsRead(String id) {
    final updated = state.notifications.map((n) {
      if (n.id == id) {
        return n.copyWith(isRead: true);
      }
      return n;
    }).toList();
    state = state.copyWith(notifications: updated);
  }

  /// Mark all notifications as read.
  void markAllAsRead() {
    final updated = state.notifications.map((n) => n.copyWith(isRead: true)).toList();
    state = state.copyWith(notifications: updated);
  }

  /// Remove a notification.
  void removeNotification(String id) {
    final updated = state.notifications.where((n) => n.id != id).toList();
    state = state.copyWith(notifications: updated);
  }

  /// Clear all notifications.
  void clearAll() {
    state = state.copyWith(notifications: []);
  }
}

/// Provider for notifications state.
final notificationProvider =
    StateNotifierProvider<NotificationNotifier, NotificationState>((ref) {
  return NotificationNotifier();
});