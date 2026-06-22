import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../core/theme/app_spacing.dart';

/// A shimmer loading placeholder widget.
///
/// Use to show elegant loading skeletons while data is being fetched.
class DSLoadingShimmer extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry? margin;

  const DSLoadingShimmer({
    super.key,
    this.width = double.infinity,
    this.height = 16,
    this.borderRadius = AppSpacing.radiusMedium,
    this.margin,
  });

  /// A card-sized shimmer placeholder.
  const DSLoadingShimmer.card({
    super.key,
    this.width = double.infinity,
    this.height = 120,
    this.borderRadius = AppSpacing.radiusLarge,
    this.margin,
  });

  /// A circular shimmer placeholder (e.g. avatar).
  factory DSLoadingShimmer.circle({
    Key? key,
    double size = 48,
  }) {
    return DSLoadingShimmer(
      key: key,
      width: size,
      height: size,
      borderRadius: size / 2,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: Shimmer.fromColors(
        baseColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        highlightColor:
            isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
    );
  }
}

/// A full card loading skeleton with multiple shimmer lines.
class DSCardShimmer extends StatelessWidget {
  const DSCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              DSLoadingShimmer.circle(size: 44),
              const SizedBox(width: AppSpacing.spacing12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const DSLoadingShimmer(height: 14, width: 120),
                    const SizedBox(height: AppSpacing.spacing8),
                    DSLoadingShimmer(
                      height: 10,
                      width: 80,
                      borderRadius: AppSpacing.radiusSmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.spacing16),
          const DSLoadingShimmer(height: 12),
          const SizedBox(height: AppSpacing.spacing8),
          const DSLoadingShimmer(height: 12, width: 200),
        ],
      ),
    );
  }
}