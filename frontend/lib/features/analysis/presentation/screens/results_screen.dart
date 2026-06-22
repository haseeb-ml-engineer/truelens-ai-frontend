import 'package:deepshield_ai/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:deepshield_ai/core/theme/app_spacing.dart';
import 'package:deepshield_ai/features/analysis/domain/entities/analysis_result.dart';
import 'package:deepshield_ai/features/analysis/presentation/providers/analysis_provider.dart';
import 'package:deepshield_ai/core/widgets/app_card.dart';
import 'package:deepshield_ai/core/widgets/risk_badge.dart' as rb;
import 'package:deepshield_ai/core/widgets/primary_button.dart';
import 'package:deepshield_ai/core/widgets/secondary_button.dart';
import 'package:deepshield_ai/core/widgets/radial_confidence_gauge.dart';
import 'package:deepshield_ai/features/analysis/presentation/widgets/explainability_accordion.dart';

class ResultsScreen extends ConsumerStatefulWidget {
  final String scanId;
  const ResultsScreen({super.key, required this.scanId});

  @override
  ConsumerState<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends ConsumerState<ResultsScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  bool _showHeatmap = true;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  rb.RiskLevel _getRiskLevel(int score) {
    if (score >= 70) return rb.RiskLevel.high;
    if (score >= 40) return rb.RiskLevel.medium;
    return rb.RiskLevel.low;
  }

  Color _getRiskColor(int score) {
    if (score >= 70) return const Color(0xFFF43F5E); // High risk red
    if (score >= 40) return const Color(0xFFF59E0B); // Medium risk amber
    return const Color(0xFF10B981); // Low risk green
  }

  IconData _getMediaIcon(String mediaType) {
    return mediaType.toLowerCase() == 'video' ? Icons.videocam_rounded : Icons.image_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // Connect to real pipeline state
    final pipelineState = ref.watch(analysisPipelineProvider);
    
    // Determine the result to display
    AnalysisResult? result;
    if (pipelineState.result?.analysisId == widget.scanId) {
      result = pipelineState.result;
    }

    // Graceful empty/missing state
    if (result == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Analysis Report'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () => context.go(RoutePaths.dashboard),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off_rounded, size: 64, color: theme.colorScheme.onSurfaceVariant),
              const SizedBox(height: AppSpacing.spacing16),
              Text(
                'Report Not Found',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: AppSpacing.spacing8),
              Text(
                'The analysis result could not be found or has expired.',
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: AppSpacing.spacing24),
              PrimaryButton(
                label: 'Return Home',
                icon: Icons.home_rounded,
                onPressed: () => context.go(RoutePaths.dashboard),
              ),
            ],
          ),
        ),
      );
    }

    final riskColor = _getRiskColor(result.riskScore);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analysis Report'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.go(RoutePaths.dashboard),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnim,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spacing24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.spacing16),

              // 1. Verdict Header
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.spacing12),
                    decoration: BoxDecoration(
                      color: riskColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      result.riskScore >= 70
                          ? Icons.warning_rounded
                          : result.riskScore >= 40
                              ? Icons.info_outline_rounded
                              : Icons.verified_rounded,
                      color: riskColor,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.spacing16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        rb.RiskBadge(
                          level: _getRiskLevel(result.riskScore),
                          label: result.prediction.toUpperCase(),
                        ),
                        const SizedBox(height: AppSpacing.spacing8),
                        Text(
                          result.reasoning,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.spacing40),

              // 2. Confidence Gauge
              Center(
                child: RadialConfidenceGauge(
                  percent: result.confidence,
                  color: riskColor,
                  calibrationText: 'AI confidence score based on forensic indicators.',
                ),
              ),

              const SizedBox(height: AppSpacing.spacing40),

              // 3. Visual Evidence (Heatmap mock area)
              Text(
                'Visual Evidence',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: AppSpacing.spacing12),
              AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: isDark ? theme.colorScheme.surfaceContainerHighest : const Color(0xFFE2E8F0),
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusMedium)),
                          ),
                          child: Center(
                            child: Icon(
                              _getMediaIcon(result.mediaType),
                              size: 48,
                              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                        if (_showHeatmap)
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusMedium)),
                                gradient: RadialGradient(
                                  colors: [
                                    riskColor.withValues(alpha: 0.6),
                                    Colors.transparent,
                                  ],
                                  stops: const [0.1, 0.8],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spacing16, vertical: AppSpacing.spacing12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Heatmap Overlay',
                            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          Switch(
                            value: _showHeatmap,
                            onChanged: (val) => setState(() => _showHeatmap = val),
                            activeThumbColor: theme.colorScheme.primary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.spacing24),

              // 4. Explainability Breakdown
              ExplainabilityAccordion(indicators: result.detectedArtifacts),

              const SizedBox(height: AppSpacing.spacing24),
              
              // 5. Technical Breakdown & Metadata
              _buildTechnicalPanel(context, result),
              
              const SizedBox(height: AppSpacing.spacing24),

              // 6. Next Steps
              if (result.recommendations.isNotEmpty) ...[
                Text(
                  'Next Steps',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: AppSpacing.spacing12),
                AppCard(
                  padding: const EdgeInsets.all(AppSpacing.spacing16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.lightbulb_outline_rounded, color: theme.colorScheme.primary, size: 20),
                      const SizedBox(width: AppSpacing.spacing12),
                      Expanded(
                        child: Text(
                          result.recommendations.join('\n• '),
                          style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.spacing32),
              ],

              // 7. Actions bar
              Row(
                children: [
                  Expanded(
                    child: SecondaryButton(
                      label: 'Export',
                      icon: Icons.download_rounded,
                      onPressed: () {
                        // Placeholder for export
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Export feature coming soon.')),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.spacing12),
                  Expanded(
                    child: PrimaryButton(
                      label: 'Share',
                      icon: Icons.share_rounded,
                      onPressed: () {
                        // Placeholder for share
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Share feature coming soon.')),
                        );
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.spacing32),

              // 8. Footer Disclosure
              const Divider(),
              const SizedBox(height: AppSpacing.spacing16),
              Text(
                'Automated analysis is a strong signal, not legal proof. Processed by ${result.analysisSource} (${result.modelVersion}) in ${result.processingTime}ms.',
                textAlign: TextAlign.center,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: AppSpacing.spacing48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTechnicalPanel(BuildContext context, AnalysisResult result) {
    final theme = Theme.of(context);
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.memory_rounded, size: 20, color: theme.colorScheme.primary),
              const SizedBox(width: AppSpacing.spacing8),
              Text('Technical Metadata', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: AppSpacing.spacing16),
          _buildMetaRow(context, 'Media Type', result.mediaType.toUpperCase()),
          _buildMetaRow(context, 'Risk Score', '${result.riskScore}/100'),
          _buildMetaRow(context, 'Analysis Source', result.analysisSource),
          _buildMetaRow(context, 'Model Version', result.modelVersion),
          _buildMetaRow(context, 'Processing Time', '${result.processingTime} ms'),
          _buildMetaRow(context, 'Timestamp', _formatTimestamp(result.timestamp)),
          
          if (result.confidenceBreakdown.isNotEmpty) ...[
            const Divider(height: AppSpacing.spacing24),
            Text('Confidence Breakdown', style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: AppSpacing.spacing8),
            ...result.confidenceBreakdown.entries.map((entry) => _buildMetaRow(context, entry.key, '${(entry.value * 100).round()}%')),
          ],
        ],
      ),
    );
  }

  Widget _buildMetaRow(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.spacing8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          Text(value, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
  
  String _formatTimestamp(DateTime time) {
    return '${time.year}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')} ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}