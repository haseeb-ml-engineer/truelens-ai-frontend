import 'package:deepshield_ai/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:deepshield_ai/core/theme/app_colors.dart';
import 'package:deepshield_ai/core/theme/app_spacing.dart';
import 'package:deepshield_ai/features/notifications/data/models/notification_model.dart';
import 'package:deepshield_ai/features/notifications/presentation/providers/notification_provider.dart';
import 'package:deepshield_ai/widgets/ds_app_bar.dart';
import 'package:deepshield_ai/widgets/ds_card.dart';

/// Notifications screen displaying scan completions, system security alerts, and promotional announcements.
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  IconData _getIconForType(NotificationType type) {
    switch (type) {
      case NotificationType.scanComplete:
        return Icons.analytics_rounded;
      case NotificationType.security:
        return Icons.shield_rounded;
      case NotificationType.update:
        return Icons.system_update_rounded;
      case NotificationType.promotion:
        return Icons.workspace_premium_rounded;
    }
  }

  Color _getColorForType(NotificationType type, ThemeData theme) {
    switch (type) {
      case NotificationType.scanComplete:
        return AppColors.primaryLight;
      case NotificationType.security:
        return AppColors.error;
      case NotificationType.update:
        return AppColors.secondaryLight;
      case NotificationType.promotion:
        return AppColors.warning;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(notificationProvider);
    final notifier = ref.read(notificationProvider.notifier);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: DSAppBar(
        title: 'Notifications',
        actions: state.notifications.isNotEmpty
            ? [
                TextButton(
                  onPressed: () => notifier.markAllAsRead(),
                  child: const Text('Mark all read'),
                ),
              ]
            : null,
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.notifications.isEmpty
              ? _buildEmptyState(theme, isDark)
              : _buildNotificationList(context, state.notifications, notifier, theme, isDark),
    );
  }

  Widget _buildEmptyState(ThemeData theme, bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.spacing24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_none_rounded,
                size: 40,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.spacing24),
            Text(
              'All Caught Up!',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.spacing8),
            Text(
              "You don't have any notifications at the moment. We'll update you when there's news.",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationList(
    BuildContext context,
    List<NotificationModel> notifications,
    NotificationNotifier notifier,
    ThemeData theme,
    bool isDark,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.spacing20,
        vertical: AppSpacing.spacing12,
      ),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final item = notifications[index];
        final icon = _getIconForType(item.type);
        final color = _getColorForType(item.type, theme);
        final dateStr = DateFormat('MMM dd, yyyy ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¢ HH:mm').format(item.createdAt);

        return Dismissible(
          key: Key(item.id),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            notifier.removeNotification(item.id);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Notification dismissed'),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () {
                    // Simple undo could reload or we can just leave it
                  },
                ),
              ),
            );
          },
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: AppSpacing.spacing24),
            margin: const EdgeInsets.only(bottom: AppSpacing.spacing12),
            decoration: BoxDecoration(
              color: theme.colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
            ),
            child: Icon(
              Icons.delete_sweep_rounded,
              color: theme.colorScheme.onErrorContainer,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.spacing12),
            child: DSCard(
              backgroundColor: !item.isRead
                  ? color.withValues(alpha: isDark ? 0.08 : 0.05)
                  : (isDark ? theme.cardTheme.color : theme.colorScheme.surface),
              onTap: () {
                notifier.markAsRead(item.id);
                // Navigate if it's a scan complete notification
                if (item.type == NotificationType.scanComplete) {
                  // Route to first mock scan for demo purposes
                  context.pushNamed(RouteNames.results, pathParameters: {'scanId': 'scan_001'});
                }
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: color, size: 20),
                  ),
                  const SizedBox(width: AppSpacing.spacing16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                item.title,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: !item.isRead ? FontWeight.bold : FontWeight.w500,
                                ),
                              ),
                            ),
                            if (!item.isRead)
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.spacing4),
                        Text(
                          item.body,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.spacing8),
                        Text(
                          dateStr,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}