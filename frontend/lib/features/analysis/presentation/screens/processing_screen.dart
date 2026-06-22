import 'dart:math' as math;
import 'package:deepshield_ai/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:deepshield_ai/core/theme/app_colors.dart';
import 'package:deepshield_ai/core/theme/app_spacing.dart';
import 'package:deepshield_ai/core/widgets/app_card.dart';
import 'package:deepshield_ai/features/analysis/presentation/models/pipeline_stage.dart';
import 'package:deepshield_ai/features/analysis/presentation/models/analysis_pipeline_state.dart';
import 'package:deepshield_ai/utils/helpers.dart';
import 'package:deepshield_ai/features/analysis/presentation/providers/analysis_provider.dart';
import 'package:deepshield_ai/features/upload/presentation/providers/upload_provider.dart';

class ProcessingScreen extends ConsumerStatefulWidget {
  const ProcessingScreen({super.key});

  @override
  ConsumerState<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends ConsumerState<ProcessingScreen>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  bool _hasNavigated = false;
  bool _pipelineStarted = false;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Start the pipeline once, after the widget is fully mounted
    if (!_pipelineStarted) {
      _pipelineStarted = true;
      _startRealPipeline();
    }
  }

  /// Kicks off the real analysis pipeline via the AnalysisService.
  void _startRealPipeline() {
    final request = ref.read(uploadProvider.notifier).buildAnalysisRequest();
    if (request == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Helpers.showSnackBar(
            context,
            'No file selected. Please upload a file first.',
            isError: true,
          );
          context.pop();
        }
      });
      return;
    }

    final pipelineState = ref.read(analysisPipelineProvider);
    if (pipelineState.isRunning) return;

    ref.read(analysisPipelineProvider.notifier).startAnalysis(request);
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final pipelineState = ref.watch(analysisPipelineProvider);

    // Animate the progress bar smoothly toward the real value
    _progressController.animateTo(
      pipelineState.overallProgress,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );

    // Navigate to results on completion (only once)
    _handleNavigation(pipelineState);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: theme.colorScheme.surface,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spacing24),
            child: Column(
              children: [
                const Spacer(flex: 1),

                // Scanning Waveform Animation
                SizedBox(
                  height: 120,
                  child: Center(
                    child: pipelineState.hasFailed
                        ? _buildErrorIcon(theme)
                        : pipelineState.isComplete
                            ? _buildSuccessIcon(theme)
                            : const ScanningWaveform(),
                  ),
                ),

                const SizedBox(height: AppSpacing.spacing32),

                // Title — reflects real pipeline state
                Text(
                  pipelineState.hasFailed
                      ? 'Analysis Failed'
                      : pipelineState.isComplete
                          ? 'Analysis Complete'
                          : 'Analysis in Progress',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: AppSpacing.spacing8),

                // Status message — driven by backend
                Text(
                  pipelineState.currentStatusMessage,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: pipelineState.hasFailed
                        ? theme.colorScheme.error
                        : theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: AppSpacing.spacing24),

                // Overall Progress Bar
                _buildProgressBar(theme, pipelineState),

                const SizedBox(height: AppSpacing.spacing32),

                // Sequential Stage Tracker — real pipeline stages
                Expanded(
                  flex: 3,
                  child: ListView.separated(
                    itemCount: pipelineState.stages.length,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: AppSpacing.spacing4),
                    itemBuilder: (context, index) {
                      final stage = pipelineState.stages[index];
                      return _StageListItem(
                        stage: stage,
                        isDark: isDark,
                      );
                    },
                  ),
                ),

                // Retry button (only on failure)
                if (pipelineState.hasFailed) ...[
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.spacing24),
                    child: SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: FilledButton.icon(
                        onPressed: () {
                          _hasNavigated = false;
                          _pipelineStarted = false;
                          _startRealPipeline();
                        },
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Retry Analysis'),
                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                AppSpacing.radiusMedium),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Navigates to the results screen when the pipeline completes.
  void _handleNavigation(AnalysisPipelineState pipelineState) {
    if (pipelineState.isComplete && !_hasNavigated && pipelineState.result != null) {
      _hasNavigated = true;
      // Use addPostFrameCallback to avoid navigating during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.goNamed(
            RouteNames.results,
            pathParameters: {'scanId': pipelineState.result!.analysisId},
          );
        }
      });
    }
  }

  Widget _buildProgressBar(ThemeData theme, AnalysisPipelineState pipelineState) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Overall Progress',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              '${(pipelineState.overallProgress * 100).round()}%',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.spacing8),
        AnimatedBuilder(
          animation: _progressController,
          builder: (context, child) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: _progressController.value,
                minHeight: 6,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(
                  pipelineState.hasFailed
                      ? theme.colorScheme.error
                      : theme.colorScheme.primary,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildErrorIcon(ThemeData theme) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: theme.colorScheme.error.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.error_outline_rounded,
        size: 48,
        color: theme.colorScheme.error,
      ),
    );
  }

  Widget _buildSuccessIcon(ThemeData theme) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.riskLow.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.check_circle_outline_rounded,
        size: 48,
        color: AppColors.riskLow,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Stage List Item Widget
// ---------------------------------------------------------------------------

/// A single row in the pipeline stage tracker.
///
/// Renders the stage icon, label, and status indicator (spinner, checkmark,
/// or error icon) based on the stage's [StageStatus].
class _StageListItem extends StatelessWidget {
  final PipelineStage stage;
  final bool isDark;

  const _StageListItem({
    required this.stage,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isActive = stage.status == StageStatus.active;
    final isCompleted = stage.status == StageStatus.completed;
    final isFailed = stage.status == StageStatus.failed;

    return AppCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.spacing16,
        vertical: AppSpacing.spacing12,
      ),
      child: Row(
        children: [
          // Step indicator
          _buildStepIndicator(theme, isActive, isCompleted, isFailed),
          const SizedBox(width: AppSpacing.spacing16),
          // Step label
          Expanded(
            child: Text(
              stage.label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: isActive || isCompleted || isFailed
                    ? FontWeight.w600
                    : FontWeight.w400,
                color: isFailed
                    ? theme.colorScheme.error
                    : isCompleted
                        ? theme.colorScheme.onSurface
                        : isActive
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          // Trailing status text
          if (isCompleted)
            Icon(
              Icons.check_rounded,
              size: 16,
              color: AppColors.riskLow.withValues(alpha: 0.8),
            ),
          if (isFailed)
            Icon(
              Icons.close_rounded,
              size: 16,
              color: theme.colorScheme.error,
            ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(
    ThemeData theme,
    bool isActive,
    bool isCompleted,
    bool isFailed,
  ) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: isFailed
            ? theme.colorScheme.error.withValues(alpha: 0.15)
            : isCompleted
                ? AppColors.riskLow.withValues(alpha: 0.15)
                : isActive
                    ? theme.colorScheme.primary.withValues(alpha: 0.15)
                    : isDark
                        ? AppColors.dividerDark
                        : AppColors.dividerLight,
        shape: BoxShape.circle,
      ),
      child: isFailed
          ? Icon(Icons.close_rounded, size: 14, color: theme.colorScheme.error)
          : isCompleted
              ? const Icon(Icons.check_rounded, size: 14, color: AppColors.riskLow)
              : isActive
                  ? Center(
                      child: SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    )
                  : Icon(stage.icon, size: 12, color: theme.colorScheme.onSurfaceVariant),
    );
  }
}

// ---------------------------------------------------------------------------
// Scanning Waveform Animation (preserved from original)
// ---------------------------------------------------------------------------

class ScanningWaveform extends StatefulWidget {
  const ScanningWaveform({super.key});

  @override
  State<ScanningWaveform> createState() => _ScanningWaveformState();
}

class _ScanningWaveformState extends State<ScanningWaveform> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final int _barCount = 12;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.primary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(_barCount, (index) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final double value = _controller.value;
            // Phase shift each bar slightly
            final double phase = (index / _barCount) * math.pi * 2;
            final double height = 30 + (math.sin(value * math.pi * 2 + phase) + 1) * 30;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 8,
              height: height,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.5 + (math.sin(value * math.pi * 2 + phase) + 1) * 0.25),
                borderRadius: BorderRadius.circular(4),
              ),
            );
          },
        );
      }),
    );
  }
}