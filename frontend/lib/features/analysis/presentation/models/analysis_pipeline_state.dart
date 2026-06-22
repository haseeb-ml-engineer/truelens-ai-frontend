import 'package:flutter/material.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../domain/entities/analysis_result.dart';
import 'pipeline_stage.dart';

/// The overall state of the analysis pipeline as consumed by the UI.
///
/// This is the single, immutable state object that the Processing screen
/// subscribes to via Riverpod. It contains the full list of pipeline stages,
/// the overall progress, and the final result or error.
class AnalysisPipelineState {
  /// The ordered list of pipeline stages and their current statuses.
  final List<PipelineStage> stages;

  /// The index of the currently active stage (-1 if not started, stages.length if done).
  final int activeStageIndex;

  /// Overall progress from 0.0 to 1.0, computed from completed stages.
  final double overallProgress;

  /// Whether the entire pipeline has completed successfully.
  final bool isComplete;

  /// Whether the pipeline is currently running.
  final bool isRunning;

  /// The final analysis result if the pipeline completed successfully.
  final AnalysisResult? result;

  /// The error that caused the pipeline to fail, if any.
  final AppException? error;

  /// Human-readable description of what is currently happening.
  final String currentStatusMessage;

  const AnalysisPipelineState({
    this.stages = const [],
    this.activeStageIndex = -1,
    this.overallProgress = 0.0,
    this.isComplete = false,
    this.isRunning = false,
    this.result,
    this.error,
    this.currentStatusMessage = 'Preparing analysis...',
  });

  /// Whether the pipeline has failed.
  bool get hasFailed => error != null;

  /// The number of stages that have completed.
  int get completedStageCount =>
      stages.where((s) => s.status == StageStatus.completed).length;

  AnalysisPipelineState copyWith({
    List<PipelineStage>? stages,
    int? activeStageIndex,
    double? overallProgress,
    bool? isComplete,
    bool? isRunning,
    AnalysisResult? result,
    AppException? error,
    String? currentStatusMessage,
  }) {
    return AnalysisPipelineState(
      stages: stages ?? this.stages,
      activeStageIndex: activeStageIndex ?? this.activeStageIndex,
      overallProgress: overallProgress ?? this.overallProgress,
      isComplete: isComplete ?? this.isComplete,
      isRunning: isRunning ?? this.isRunning,
      result: result ?? this.result,
      error: error ?? this.error,
      currentStatusMessage: currentStatusMessage ?? this.currentStatusMessage,
    );
  }

  /// Returns the default pipeline stages for a forensic analysis.
  ///
  /// These labels correspond exactly to the `onProgress` strings emitted
  /// by [AnalysisPipeline.execute].
  static List<PipelineStage> defaultStages() {
    return const [
      PipelineStage(
        label: 'Uploading media',
        icon: Icons.cloud_upload_rounded,
      ),
      PipelineStage(
        label: 'Validating file',
        icon: Icons.verified_user_rounded,
      ),
      PipelineStage(
        label: 'Generating forensic prompt',
        icon: Icons.edit_note_rounded,
      ),
      PipelineStage(
        label: 'Running AI analysis',
        icon: Icons.psychology_rounded,
      ),
      PipelineStage(
        label: 'Parsing & validating results',
        icon: Icons.data_object_rounded,
      ),
      PipelineStage(
        label: 'Finalizing report',
        icon: Icons.assignment_turned_in_rounded,
      ),
    ];
  }

  /// Returns the initial state for a new pipeline run.
  factory AnalysisPipelineState.initial() {
    return AnalysisPipelineState(
      stages: defaultStages(),
      activeStageIndex: -1,
      overallProgress: 0.0,
      isComplete: false,
      isRunning: false,
      currentStatusMessage: 'Preparing analysis...',
    );
  }
}
