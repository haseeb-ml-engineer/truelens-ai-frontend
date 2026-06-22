import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';

/// A premium, customizable button widget for TrueLens AI.
///
/// Supports primary, secondary, outline, and ghost variants
/// with optional gradient backgrounds and loading states.
class DSButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final DSButtonVariant variant;
  final IconData? icon;
  final bool isLoading;
  final bool isExpanded;
  final double? width;
  final double height;

  const DSButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = DSButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.isExpanded = true,
    this.width,
    this.height = AppSpacing.buttonHeight,
  });

  /// Convenience constructor for secondary buttons.
  const DSButton.secondary({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isExpanded = true,
    this.width,
    this.height = AppSpacing.buttonHeight,
  }) : variant = DSButtonVariant.secondary;

  /// Convenience constructor for outline buttons.
  const DSButton.outline({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isExpanded = true,
    this.width,
    this.height = AppSpacing.buttonHeight,
  }) : variant = DSButtonVariant.outline;

  /// Convenience constructor for ghost/text buttons.
  const DSButton.ghost({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isExpanded = true,
    this.width,
    this.height = AppSpacing.buttonHeight,
  }) : variant = DSButtonVariant.ghost;

  /// Convenience constructor for gradient buttons.
  const DSButton.gradient({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isExpanded = true,
    this.width,
    this.height = AppSpacing.buttonHeight,
  }) : variant = DSButtonVariant.gradient;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine styling based on variant
    final bool isGradient = variant == DSButtonVariant.gradient;
    final bool isOutline = variant == DSButtonVariant.outline;
    final bool isGhost = variant == DSButtonVariant.ghost;
    final bool isSecondary = variant == DSButtonVariant.secondary;

    Color bgColor;
    Color fgColor;
    BorderSide? border;

    if (isGradient) {
      bgColor = Colors.transparent;
      fgColor = Colors.white;
    } else if (isOutline) {
      bgColor = Colors.transparent;
      fgColor = colorScheme.onSurface;
      border = BorderSide(color: colorScheme.outline);
    } else if (isGhost) {
      bgColor = Colors.transparent;
      fgColor = colorScheme.primary;
    } else if (isSecondary) {
      bgColor = colorScheme.primaryContainer;
      fgColor = colorScheme.primary;
    } else {
      bgColor = colorScheme.primary;
      fgColor = colorScheme.onPrimary;
    }

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

    Widget button = Material(
      color: isGradient ? Colors.transparent : bgColor,
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
            border: border != null ? Border.fromBorderSide(border) : null,
            gradient: isGradient ? AppColors.primaryGradient : null,
          ),
          child: Center(child: buttonContent),
        ),
      ),
    );

    return button;
  }
}

/// Button style variants.
enum DSButtonVariant { primary, secondary, outline, ghost, gradient }