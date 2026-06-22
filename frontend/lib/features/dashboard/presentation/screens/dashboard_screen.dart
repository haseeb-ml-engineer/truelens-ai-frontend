import 'package:deepshield_ai/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:deepshield_ai/core/theme/app_colors.dart';
import 'package:deepshield_ai/core/theme/app_spacing.dart';
import 'package:deepshield_ai/features/analysis/data/models/scan_result_model.dart';
import 'package:deepshield_ai/features/authentication/presentation/providers/auth_provider.dart';
import 'package:deepshield_ai/utils/extensions.dart';
import 'package:deepshield_ai/utils/helpers.dart';
import 'package:deepshield_ai/core/widgets/app_card.dart';
import 'package:deepshield_ai/core/widgets/risk_badge.dart' as rb;
import 'package:deepshield_ai/core/widgets/primary_button.dart';
import 'package:deepshield_ai/features/dashboard/presentation/widgets/trust_score_widget.dart';
import 'package:deepshield_ai/features/dashboard/presentation/widgets/insight_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final user = ref.watch(currentUserProvider);
    final mockScans = ScanResultModel.mockList();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spacing24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.spacing24),

                // 1. Personalized Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Good ${_getTimeOfDay()}, ${user?.fullName ?? 'User'}",
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.spacing4),
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.riskLow,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.spacing8),
                            Text(
                              'All clear — no flagged content in the last 7 days',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Optional Avatar or Notification Bell
                    CircleAvatar(
                      backgroundColor: theme.colorScheme.surfaceContainerHighest,
                      child: Icon(Icons.person_outline, color: theme.colorScheme.onSurface),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.spacing32),

                // 2. Trust Score Widget
                const TrustScoreWidget(
                  score: 0.94,
                  statusText: 'Your recent scans have been high-confidence — detection is working well for your media types.',
                ),

                const SizedBox(height: AppSpacing.spacing24),

                // 3. Quick Action
                PrimaryButton(
                  label: 'New Scan',
                  icon: Icons.add_rounded,
                  onPressed: () => context.push(RoutePaths.upload),
                  height: 56,
                ),

                const SizedBox(height: AppSpacing.spacing32),

                // 4. Insight of the Day
                const InsightCard(
                  insight: 'Deepfakes using facial reenactment are most commonly detected by checking temporal inconsistency around the mouth and eyes.',
                ),

                const SizedBox(height: AppSpacing.spacing32),

                // 5. Recent Results Strip
                _buildSectionHeader(
                  context,
                  'Recent Scans',
                  trailing: GestureDetector(
                    onTap: () => context.go(RoutePaths.history),
                    child: Text(
                      'View History',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.spacing16),
                SizedBox(
                  height: 140,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: mockScans.length,
                    separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.spacing16),
                    itemBuilder: (context, index) {
                      final scan = mockScans[index];
                      return _CompactScanCard(scan: scan);
                    },
                  ),
                ),

                const SizedBox(height: AppSpacing.spacing32),

                // 6. Trends Preview (Sparkline)
                _buildSectionHeader(context, 'Activity Trends'),
                const SizedBox(height: AppSpacing.spacing16),
                AppCard(
                  padding: const EdgeInsets.all(AppSpacing.spacing20),
                  child: SizedBox(
                    height: 120,
                    child: _TrendSparkline(isDark: isDark),
                  ),
                ),

                const SizedBox(height: AppSpacing.spacing48),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getTimeOfDay() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'morning';
    if (hour < 17) return 'afternoon';
    return 'evening';
  }

  Widget _buildSectionHeader(BuildContext context, String title, {Widget? trailing}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        ?trailing,
      ],
    );
  }
}

class _CompactScanCard extends StatelessWidget {
  final ScanResultModel scan;

  const _CompactScanCard({required this.scan});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      onTap: () => context.pushNamed(RouteNames.results, pathParameters: {'scanId': scan.id}),
      padding: const EdgeInsets.all(AppSpacing.spacing16),
      child: SizedBox(
        width: 180,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Helpers.mediaTypeIcon(scan.mediaType),
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                rb.RiskBadge(
                  level: rb.RiskLevel.values.firstWhere((e) => e.name == scan.riskLevel.name, orElse: () => rb.RiskLevel.low),
                  label: scan.aiProbability.asPercentage,
                ),
              ],
            ),
            Column(
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
                Text(
                  scan.scannedAt.timeAgo,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TrendSparkline extends StatelessWidget {
  final bool isDark;

  const _TrendSparkline({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final data = [2, 5, 3, 8, 4, 10, 6];

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: data.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.toDouble())).toList(),
            isCurved: true,
            color: theme.colorScheme.primary,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
            ),
          ),
        ],
      ),
    );
  }
}