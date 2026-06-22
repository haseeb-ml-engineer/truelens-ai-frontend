import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

enum RiskLevel { low, medium, high }

class RiskBadge extends StatelessWidget {
  final RiskLevel level;
  final String label;

  const RiskBadge({
    super.key,
    required this.level,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Color badgeColor;
    switch (level) {
      case RiskLevel.low:
        badgeColor = AppColors.riskLow;
        break;
      case RiskLevel.medium:
        badgeColor = AppColors.riskMedium;
        break;
      case RiskLevel.high:
        badgeColor = AppColors.riskHigh;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.spacing12,
        vertical: AppSpacing.spacing4,
      ),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: isDark ? 0.2 : 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        border: Border.all(
          color: badgeColor.withValues(alpha: 0.5),
        ),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelMedium?.copyWith(
          color: isDark ? badgeColor.withValues(alpha: 0.9) : badgeColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
