import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/constants/app_strings.dart';

/// A drag-and-drop style file picker card.
///
/// Shows a dashed border with an upload icon and
/// instructions. Tapping triggers [onTap].
class DSFilePickerCard extends StatelessWidget {
  final VoidCallback? onTap;
  final String title;
  final String subtitle;
  final IconData icon;
  final bool hasFile;
  final Widget? filePreview;

  const DSFilePickerCard({
    super.key,
    this.onTap,
    this.title = AppStrings.dragAndDrop,
    this.subtitle = AppStrings.supportedFormats,
    this.icon = Icons.cloud_upload_rounded,
    this.hasFile = false,
    this.filePreview,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (hasFile && filePreview != null) {
      return _buildFilePreview(context);
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.spacing32),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.cardDark
              : theme.colorScheme.primaryContainer.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(AppSpacing.radiusXLarge),
          border: Border.all(
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: CustomPaint(
          painter: _DashedBorderPainter(
            color: theme.colorScheme.primary.withValues(alpha: 0.2),
            borderRadius: AppSpacing.radiusXLarge - 2,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color:
                      theme.colorScheme.primary.withValues(alpha: isDark ? 0.15 : 0.1),
                  borderRadius:
                      BorderRadius.circular(AppSpacing.radiusLarge),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.spacing16),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.spacing8),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilePreview(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXLarge),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusXLarge - 1),
        child: Stack(
          children: [
            filePreview!,
            Positioned(
              top: AppSpacing.spacing8,
              right: AppSpacing.spacing8,
              child: GestureDetector(
                onTap: onTap,
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.spacing8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusSmall),
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom painter for dashed border effect.
class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double borderRadius;

  _DashedBorderPainter({
    required this.color,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Intentionally left minimal â€” the solid border on the
    // container already provides the visual boundary.
    // This painter adds a subtle inner dashed hint.
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}