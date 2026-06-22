import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import 'package:deepshield_ai/features/analysis/data/models/scan_result_model.dart';

/// A compact badge showing the risk level with color coding.
class DSRiskBadge extends StatelessWidget {
  final RiskLevel level;
  final bool isCompact;

  const DSRiskBadge({
    super.key,
    required this.level,
    this.isCompact = false,
  });

  Color get _color {
    switch (level) {
      case RiskLevel.low:
        return AppColors.riskLow;
      case RiskLevel.medium:
        return AppColors.riskMedium;
      case RiskLevel.high:
        return AppColors.riskHigh;
    }
  }

  String get _label {
    switch (level) {
      case RiskLevel.low:
        return 'Low';
      case RiskLevel.medium:
        return 'Medium';
      case RiskLevel.high:
        return 'High';
    }
  }

  IconData get _icon {
    switch (level) {
      case RiskLevel.low:
        return Icons.check_circle_rounded;
      case RiskLevel.medium:
        return Icons.warning_rounded;
      case RiskLevel.high:
        return Icons.error_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? AppSpacing.spacing8 : AppSpacing.spacing12,
        vertical: isCompact ? AppSpacing.spacing2 : AppSpacing.spacing6,
      ),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        border: Border.all(
          color: _color.withValues(alpha: 0.3),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _icon,
            size: isCompact ? 12 : 14,
            color: _color,
          ),
          SizedBox(width: isCompact ? 3 : AppSpacing.spacing4),
          Text(
            _label,
            style: TextStyle(
              fontSize: isCompact ? 10 : 12,
              fontWeight: FontWeight.w600,
              color: _color,
            ),
          ),
        ],
      ),
    );
  }
}