import 'package:flutter/material.dart';
import '../core/theme/app_spacing.dart';

/// A premium card widget with optional gradient border and glow effects.
class DSCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final LinearGradient? gradientBorder;
  final double borderRadius;
  final Color? backgroundColor;

  const DSCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.gradientBorder,
    this.borderRadius = AppSpacing.radiusLarge,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Widget card = Container(
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.cardTheme.color,
        borderRadius: BorderRadius.circular(borderRadius),
        border: gradientBorder == null
            ? (isDark
                ? Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.15),
                  )
                : null)
            : null,
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(AppSpacing.spacing16),
            child: child,
          ),
        ),
      ),
    );

    // Wrap in gradient border if specified
    if (gradientBorder != null) {
      card = Container(
        margin: margin,
        decoration: BoxDecoration(
          gradient: gradientBorder,
          borderRadius: BorderRadius.circular(borderRadius + 1),
        ),
        child: Container(
          margin: const EdgeInsets.all(1.5),
          decoration: BoxDecoration(
            color: backgroundColor ?? theme.cardTheme.color,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(borderRadius),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(borderRadius),
              child: Padding(
                padding: padding ?? const EdgeInsets.all(AppSpacing.spacing16),
                child: child,
              ),
            ),
          ),
        ),
      );
    }

    return card;
  }
}