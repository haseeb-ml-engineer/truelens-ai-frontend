import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';

/// A labeled section container used throughout the Settings screen.
class SettingsSection extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;

  const SettingsSection({
    super.key,
    required this.title,
    this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: AppSpacing.spacing4),
          Text(
            subtitle!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.spacing12),
        child,
      ],
    );
  }
}
