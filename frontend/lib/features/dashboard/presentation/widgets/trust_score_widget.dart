import 'package:flutter/material.dart';
import 'package:deepshield_ai/core/theme/app_spacing.dart';
import 'package:deepshield_ai/core/widgets/app_card.dart';

class TrustScoreWidget extends StatelessWidget {
  final double score; // e.g., 0.98 for 98%
  final String statusText;

  const TrustScoreWidget({
    super.key,
    required this.score,
    required this.statusText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scorePercent = (score * 100).toInt();

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.spacing20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.2),
                width: 4,
              ),
            ),
            child: Center(
              child: Text(
                '$scorePercent',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.spacing20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'System Trust Score',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: AppSpacing.spacing4),
                Text(
                  statusText,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
