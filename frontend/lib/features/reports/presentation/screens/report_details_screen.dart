import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:deepshield_ai/core/theme/app_colors.dart';
import 'package:deepshield_ai/core/theme/app_spacing.dart';
import 'package:deepshield_ai/core/constants/app_strings.dart';
import 'package:deepshield_ai/features/reports/data/models/report_model.dart';
import 'package:deepshield_ai/features/reports/data/repositories/mock_report_repository.dart';
import 'package:deepshield_ai/utils/helpers.dart';
import 'package:deepshield_ai/widgets/ds_app_bar.dart';
import 'package:deepshield_ai/widgets/ds_button.dart';
import 'package:deepshield_ai/widgets/ds_card.dart';
import 'package:deepshield_ai/widgets/ds_risk_badge.dart';

/// Detailed scan report screen displaying extended analytical scores,
/// execution timeline, metadata, and export choices.
class ReportDetailsScreen extends StatefulWidget {
  final String scanId;
  const ReportDetailsScreen({super.key, required this.scanId});

  @override
  State<ReportDetailsScreen> createState() => _ReportDetailsScreenState();
}

class _ReportDetailsScreenState extends State<ReportDetailsScreen> {
  final MockReportRepository _reportService = MockReportRepository();
  ReportModel? _report;
  bool _isLoading = true;
  bool _isDownloading = false;
  bool _isSharing = false;

  @override
  void initState() {
    super.initState();
    _loadReport();
  }

  Future<void> _loadReport() async {
    setState(() => _isLoading = true);
    try {
      final report = await _reportService.getReport(widget.scanId);
      setState(() {
        _report = report;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load report: $e')),
        );
      }
    }
  }

  Future<void> _downloadReport() async {
    if (_report == null) return;
    setState(() => _isDownloading = true);
    try {
      final path = await _reportService.downloadReportPdf(_report!.analysisId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.tertiaryLight,
            content: Row(
              children: [
                const Icon(Icons.check_circle_outline, color: Colors.white),
                const SizedBox(width: AppSpacing.spacing8),
                Expanded(child: Text('Report saved to $path')),
              ],
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Download failed: $e')),
        );
      }
    } finally {
      setState(() => _isDownloading = false);
    }
  }

  Future<void> _shareReport() async {
    if (_report == null) return;
    setState(() => _isSharing = true);
    try {
      final url = await _reportService.shareReport(_report!.analysisId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.primaryLight,
            content: Row(
              children: [
                const Icon(Icons.share_rounded, color: Colors.white),
                const SizedBox(width: AppSpacing.spacing8),
                Expanded(child: Text('Copied report link: $url')),
              ],
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sharing failed: $e')),
        );
      }
    } finally {
      setState(() => _isSharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (_isLoading) {
      return const Scaffold(
        appBar: DSAppBar(title: AppStrings.analysisReport),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_report == null) {
      return Scaffold(
        appBar: const DSAppBar(title: AppStrings.analysisReport),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 64,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: AppSpacing.spacing16),
              Text(
                'Report not found',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.spacing8),
              DSButton(
                label: 'Go Back',
                onPressed: () => context.pop(),
              ),
            ],
          ),
        ),
      );
    }

    final scan = _report!.scanResult;
    final riskColor = Helpers.riskColor(scan.riskLevel);

    return Scaffold(
      appBar: DSAppBar(
        title: 'Report: ${scan.fileName}',
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _loadReport,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spacing20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.spacing8),

            // ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ Top Summary Header Card ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬
            DSCard(
              backgroundColor: isDark
                  ? theme.colorScheme.surfaceContainer
                  : theme.colorScheme.surface,
              padding: const EdgeInsets.all(AppSpacing.spacing20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Report ID: ${_report!.analysisId}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.spacing4),
                          Text(
                            'Model: ${_report!.modelVersion}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      DSRiskBadge(level: scan.riskLevel),
                    ],
                  ),
                  const Divider(height: AppSpacing.spacing32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _SummaryStat(
                        label: 'AI Probability',
                        value: '${(scan.aiProbability * 100).toStringAsFixed(1)}%',
                        color: riskColor,
                      ),
                      _SummaryStat(
                        label: 'Confidence',
                        value: '${(scan.confidenceScore * 100).toStringAsFixed(0)}%',
                        color: theme.colorScheme.primary,
                      ),
                      _SummaryStat(
                        label: 'Type',
                        value: scan.mediaTypeLabel,
                        color: theme.colorScheme.secondary,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.spacing24),

            // ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ Detailed Model Breakdown ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬
            Text(
              'Signal Anomaly Breakdown',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.spacing12),
            DSCard(
              child: Column(
                children: _report!.detailedScores.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.spacing8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              entry.key,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '${(entry.value * 100).toStringAsFixed(0)}%',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: entry.value > 0.7
                                    ? AppColors.error
                                    : entry.value > 0.4
                                        ? AppColors.warning
                                        : AppColors.success,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.spacing6),
                        LinearProgressIndicator(
                          value: entry.value,
                          backgroundColor: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            entry.value > 0.7
                                ? AppColors.error
                                : entry.value > 0.4
                                    ? AppColors.warning
                                    : AppColors.success,
                          ),
                          borderRadius: BorderRadius.circular(4),
                          minHeight: 6,
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: AppSpacing.spacing24),

            // ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ Processing Pipeline Timeline ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬
            Text(
              'Analysis Execution Trace',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.spacing12),
            DSCard(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _report!.timeline.length,
                itemBuilder: (context, index) {
                  final entry = _report!.timeline[index];
                  final isLast = index == _report!.timeline.length - 1;
                  final timeStr = DateFormat('HH:mm:ss').format(entry.timestamp);

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              color: entry.isCompleted
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.outlineVariant,
                              shape: BoxShape.circle,
                            ),
                            child: entry.isCompleted
                                ? const Icon(
                                    Icons.check,
                                    size: 10,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                          if (!isLast)
                            Container(
                              width: 2,
                              height: 40,
                              color: entry.isCompleted
                                  ? theme.colorScheme.primary.withValues(alpha: 0.5)
                                  : theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                            ),
                        ],
                      ),
                      const SizedBox(width: AppSpacing.spacing16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.label,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: entry.isCompleted
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.spacing2),
                            Text(
                              timeStr,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.spacing16),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: AppSpacing.spacing32),

            // ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ Action Buttons ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬
            Row(
              children: [
                Expanded(
                  child: DSButton.outline(
                    label: _isDownloading ? 'Downloading...' : 'Download PDF',
                    icon: _isDownloading
                        ? Icons.hourglass_empty_rounded
                        : Icons.picture_as_pdf_rounded,
                    onPressed: _isDownloading ? null : _downloadReport,
                    height: AppSpacing.buttonHeightSmall,
                  ),
                ),
                const SizedBox(width: AppSpacing.spacing12),
                Expanded(
                  child: DSButton.gradient(
                    label: _isSharing ? 'Sharing...' : 'Share Report',
                    icon: _isSharing
                        ? Icons.hourglass_empty_rounded
                        : Icons.share_rounded,
                    onPressed: _isSharing ? null : _shareReport,
                    height: AppSpacing.buttonHeightSmall,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.spacing32),
          ],
        ),
      ),
    );
  }
}

class _SummaryStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _SummaryStat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: AppSpacing.spacing4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}