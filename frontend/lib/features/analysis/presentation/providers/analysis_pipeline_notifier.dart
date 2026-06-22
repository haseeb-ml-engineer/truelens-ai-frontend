import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/analysis_service.dart';
import '../../../../core/exceptions/app_exceptions.dart';

import '../../domain/entities/analysis_request.dart';
import '../../domain/entities/analysis_result.dart';
import '../../domain/repositories/analysis_repository.dart';
import '../models/analysis_pipeline_state.dart';
import '../models/pipeline_stage.dart';

/// Maps raw progress strings from [AnalysisPipeline] to stage indices.
///
/// The keys are substrings matched against the `onProgress` callback messages
/// emitted by the backend pipeline. This is the ONLY coupling point between
/// the UI and the backend progress reporting.
const Map<String, int> _progressStageMap = {
  'Uploading': 0,
  'Validating': 1,
  'Generating': 2,
  'Running': 3,
  'Parsing': 4,
  'complete': 5,
};

/// Resolves a raw progress string from the backend to a stage index.
///
/// Returns -1 if the string does not match any known stage.
int _resolveStageIndex(String progressMessage) {
  for (final entry in _progressStageMap.entries) {
    if (progressMessage.toLowerCase().contains(entry.key.toLowerCase())) {
      return entry.value;
    }
  }
  return -1;
}

/// The Riverpod [StateNotifier] that bridges [AnalysisService] progress
/// callbacks to the immutable [AnalysisPipelineState] consumed by the UI.
///
/// This notifier:
/// - Receives an [AnalysisService] via DI (not a concrete implementation).
/// - Translates raw `onProgress(String)` callbacks into structured stage updates.
/// - Holds the final [AnalysisResult] or [AppException] for downstream consumption.
/// - Supports retry by re-running the pipeline from the initial state.
class AnalysisPipelineNotifier extends StateNotifier<AnalysisPipelineState> {
  final AnalysisService _analysisService;
  final AnalysisRepository _analysisRepository;

  AnalysisPipelineNotifier(this._analysisService, this._analysisRepository)
      : super(AnalysisPipelineState.initial());

  AnalysisRequest? _activeRequest;

  /// Starts the real analysis pipeline.
  ///
  /// The processing screen calls this once. The [onProgress] callback from
  /// [AnalysisService.runAnalysis] drives all state transitions.
  Future<void> startAnalysis(AnalysisRequest request) async {
    _activeRequest = request;

    // Reset to initial state
    state = AnalysisPipelineState.initial().copyWith(isRunning: true);

    // Activate the first stage (uploading) immediately
    _advanceToStage(0, 'Uploading media...');

    final result = await _analysisService.runAnalysis(
      request: request,
      onProgress: _handleProgressUpdate,
    );

    // Process the final result
    result.fold(
      (data) => _handleSuccess(data),
      (error) => _handleFailure(error),
    );
  }

  /// Handles a raw progress string from the backend pipeline.
  void _handleProgressUpdate(String progressMessage) {
    final stageIndex = _resolveStageIndex(progressMessage);
    if (stageIndex >= 0) {
      _advanceToStage(stageIndex, progressMessage);
    }
  }

  /// Advances the pipeline visualization to the given stage index.
  ///
  /// All stages before [targetIndex] are marked as completed.
  /// The stage at [targetIndex] is marked as active.
  void _advanceToStage(int targetIndex, String statusMessage) {
    if (!mounted) return;

    final updatedStages = List<PipelineStage>.from(state.stages);
    for (int i = 0; i < updatedStages.length; i++) {
      if (i < targetIndex) {
        updatedStages[i] = updatedStages[i].copyWith(
          status: StageStatus.completed,
          timestamp: DateTime.now(),
        );
      } else if (i == targetIndex) {
        updatedStages[i] = updatedStages[i].copyWith(
          status: StageStatus.active,
          timestamp: DateTime.now(),
        );
      }
      // Stages after targetIndex remain pending (unchanged).
    }

    final progress = targetIndex / updatedStages.length;

    state = state.copyWith(
      stages: updatedStages,
      activeStageIndex: targetIndex,
      overallProgress: progress.clamp(0.0, 1.0),
      currentStatusMessage: statusMessage,
    );
  }

  /// Handles a successful pipeline completion.
  Future<void> _handleSuccess(AnalysisResult result) async {
    if (!mounted) return;

    // Persist to Hive before navigating to results.
    await _analysisRepository.saveAnalysis(
      result,
      mediaPath: _activeRequest?.filePath,
    );

    final updatedStages = state.stages
        .map((s) => s.copyWith(
              status: StageStatus.completed,
              timestamp: DateTime.now(),
            ))
        .toList();

    state = state.copyWith(
      stages: updatedStages,
      activeStageIndex: updatedStages.length,
      overallProgress: 1.0,
      isComplete: true,
      isRunning: false,
      result: result,
      currentStatusMessage: 'Analysis complete',
    );
  }

  /// Handles a pipeline failure.
  void _handleFailure(AppException error) {
    if (!mounted) return;

    // Mark the currently active stage as failed
    final updatedStages = List<PipelineStage>.from(state.stages);
    final failedIndex = state.activeStageIndex;
    if (failedIndex >= 0 && failedIndex < updatedStages.length) {
      updatedStages[failedIndex] = updatedStages[failedIndex].copyWith(
        status: StageStatus.failed,
        timestamp: DateTime.now(),
      );
    }

    state = state.copyWith(
      stages: updatedStages,
      isRunning: false,
      error: error,
      currentStatusMessage: error.message,
    );
  }

  /// Resets the pipeline to allow a retry.
  void reset() {
    state = AnalysisPipelineState.initial();
  }

  /// Retries the analysis with the same request.
  Future<void> retry(AnalysisRequest request) async {
    reset();
    await startAnalysis(request);
  }
}
