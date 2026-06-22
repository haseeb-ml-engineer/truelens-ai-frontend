import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isExpanded;
  final double? width;
  final double height;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isExpanded = true,
    this.width,
    this.height = AppSpacing.buttonHeight,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bgColor = colorScheme.primary;
    final fgColor = colorScheme.onPrimary;

    Widget buttonContent = Row(
      mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: fgColor,
            ),
          ),
          const SizedBox(width: AppSpacing.spacing8),
        ],
        if (icon != null && !isLoading) ...[
          Icon(icon, size: AppSpacing.iconMedium, color: fgColor),
          const SizedBox(width: AppSpacing.spacing8),
        ],
        Text(
          label,
          style: theme.textTheme.titleSmall?.copyWith(
            color: fgColor,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );

    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
      child: InkWell(
        onTap: isLoading ? null : onPressed,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        child: Container(
          width: isExpanded ? double.infinity : width,
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spacing20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          ),
          child: Center(child: buttonContent),
        ),
      ),
    );
  }
}
