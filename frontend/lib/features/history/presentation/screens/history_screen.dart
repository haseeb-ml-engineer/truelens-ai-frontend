import 'package:deepshield_ai/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:deepshield_ai/core/theme/app_spacing.dart';
import 'package:deepshield_ai/core/constants/app_strings.dart';
import 'package:deepshield_ai/features/analysis/data/models/scan_result_model.dart';
import 'package:deepshield_ai/features/history/presentation/providers/history_provider.dart';
import 'package:deepshield_ai/utils/extensions.dart';
import 'package:deepshield_ai/utils/helpers.dart';
import 'package:deepshield_ai/widgets/ds_card.dart';
import 'package:deepshield_ai/widgets/ds_risk_badge.dart';
import 'package:deepshield_ai/widgets/ds_text_field.dart';

/// History screen showing all past scans with search and filter.
class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(historyProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spacing20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.spacing16),

              // Title
              Text(
                AppStrings.history,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: AppSpacing.spacing16),

              // Search bar
              DSTextField(
                hint: AppStrings.searchScans,
                prefixIcon: Icons.search_rounded,
                onChanged: (query) {
                  ref.read(historyProvider.notifier).search(query);
                },
              ),

              const SizedBox(height: AppSpacing.spacing16),

              // Filter chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _FilterChip(
                      label: AppStrings.filterAll,
                      isSelected: state.filterType == null,
                      onTap: () => ref
                          .read(historyProvider.notifier)
                          .filterByType(null),
                    ),
                    const SizedBox(width: AppSpacing.spacing8),
                    _FilterChip(
                      label: AppStrings.filterImages,
                      isSelected: state.filterType == MediaType.image,
                      icon: Icons.image_rounded,
                      onTap: () => ref
                          .read(historyProvider.notifier)
                          .filterByType(MediaType.image),
                    ),
                    const SizedBox(width: AppSpacing.spacing8),
                    _FilterChip(
                      label: AppStrings.filterVideos,
                      isSelected: state.filterType == MediaType.video,
                      icon: Icons.videocam_rounded,
                      onTap: () => ref
                          .read(historyProvider.notifier)
                          .filterByType(MediaType.video),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.spacing16),

              // Results count
              Text(
                '${state.scans.length} scans found',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),

              const SizedBox(height: AppSpacing.spacing12),

              // Scan list
              Expanded(
                child: state.scans.isEmpty
                    ? _EmptyState()
                    : ListView.separated(
                        itemCount: state.scans.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: AppSpacing.spacing12),
                        itemBuilder: (context, index) {
                          final scan = state.scans[index];
                          return _HistoryListItem(
                            scan: scan,
                            onTap: () =>
                                context.pushNamed(RouteNames.results, pathParameters: {'scanId': scan.id}),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Filter chip for All / Images / Videos.
class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final IconData? icon;
  final VoidCallback? onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppSpacing.animFast,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.spacing16,
          vertical: AppSpacing.spacing8,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 14,
                color: isSelected
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: AppSpacing.spacing4),
            ],
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: isSelected
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A detailed history list item card.
class _HistoryListItem extends StatelessWidget {
  final ScanResultModel scan;
  final VoidCallback? onTap;

  const _HistoryListItem({required this.scan, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DSCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.spacing16),
      child: Row(
        children: [
          // Thumbnail
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color:
                  Helpers.riskColor(scan.riskLevel).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
            ),
            child: Icon(
              Helpers.mediaTypeIcon(scan.mediaType),
              color: Helpers.riskColor(scan.riskLevel),
              size: 28,
            ),
          ),
          const SizedBox(width: AppSpacing.spacing16),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  scan.fileName,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.spacing4),
                Row(
                  children: [
                    Text(
                      scan.scannedAt.formattedDate,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.spacing8),
                    Container(
                      width: 3,
                      height: 3,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onSurfaceVariant,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.spacing8),
                    Text(
                      scan.mediaTypeLabel,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Risk + probability
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                scan.aiProbability.asPercentage,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Helpers.riskColor(scan.riskLevel),
                ),
              ),
              const SizedBox(height: AppSpacing.spacing6),
              DSRiskBadge(level: scan.riskLevel, isCompact: true),
            ],
          ),
        ],
      ),
    );
  }
}

/// Empty state widget when no scans match.
class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 64,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
          ),
          const SizedBox(height: AppSpacing.spacing16),
          Text(
            AppStrings.noScansYet,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}