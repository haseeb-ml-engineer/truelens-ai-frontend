import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';

/// A premium circular progress indicator with percentage display.
class DSProgressIndicator extends StatelessWidget {
  final double percent;
  final double radius;
  final Color? progressColor;
  final Color? backgroundColor;
  final String? centerText;
  final Widget? center;
  final double lineWidth;
  final bool animation;

  const DSProgressIndicator({
    super.key,
    required this.percent,
    this.radius = 60,
    this.progressColor,
    this.backgroundColor,
    this.centerText,
    this.center,
    this.lineWidth = 10,
    this.animation = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return CircularPercentIndicator(
      radius: radius,
      lineWidth: lineWidth,
      percent: percent.clamp(0.0, 1.0),
      center: center ??
          (centerText != null
              ? Text(
                  centerText!,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: progressColor ?? theme.colorScheme.primary,
                  ),
                )
              : null),
      progressColor: progressColor ?? theme.colorScheme.primary,
      backgroundColor: backgroundColor ??
          (isDark
              ? AppColors.dividerDark.withValues(alpha: 0.3)
              : AppColors.dividerLight),
      circularStrokeCap: CircularStrokeCap.round,
      animation: animation,
      animationDuration: 1200,
    );
  }
}

/// A premium linear progress indicator.
class DSLinearProgress extends StatelessWidget {
  final double percent;
  final Color? progressColor;
  final Color? backgroundColor;
  final double height;
  final bool showLabel;

  const DSLinearProgress({
    super.key,
    required this.percent,
    this.progressColor,
    this.backgroundColor,
    this.height = 8,
    this.showLabel = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (showLabel) ...[
          Text(
            '${(percent * 100).toStringAsFixed(0)}%',
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: progressColor ?? theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.spacing4),
        ],
        LinearPercentIndicator(
          percent: percent.clamp(0.0, 1.0),
          lineHeight: height,
          progressColor: progressColor ?? theme.colorScheme.primary,
          backgroundColor: backgroundColor ??
              (isDark
                  ? AppColors.dividerDark.withValues(alpha: 0.3)
                  : AppColors.dividerLight),
          barRadius: Radius.circular(height / 2),
          animation: true,
          animationDuration: 800,
          padding: EdgeInsets.zero,
        ),
      ],
    );
  }
}