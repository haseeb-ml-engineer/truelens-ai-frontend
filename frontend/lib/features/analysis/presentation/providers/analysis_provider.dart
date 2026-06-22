import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:deepshield_ai/core/services/analysis_service.dart';
import 'package:deepshield_ai/core/services/analysis_service_impl.dart';
import 'package:deepshield_ai/core/api/analysis_provider.dart' as api;
import 'package:deepshield_ai/features/analysis/domain/repositories/analysis_repository.dart';
import 'package:deepshield_ai/features/analysis/domain/entities/analysis_request.dart';
import 'package:deepshield_ai/features/history/domain/repositories/history_repository.dart';
import 'package:deepshield_ai/features/analysis/data/models/scan_result_model.dart';
import 'package:deepshield_ai/features/analysis/data/datasources/analysis_local_datasource.dart';
import 'package:deepshield_ai/features/analysis/data/repositories/analysis_repository_impl.dart';
import 'package:deepshield_ai/features/history/data/repositories/mock_history_repository.dart';
import 'package:deepshield_ai/features/analysis/presentation/providers/analysis_pipeline_notifier.dart';
import 'package:deepshield_ai/features/analysis/presentation/models/analysis_pipeline_state.dart';
import 'package:deepshield_ai/features/settings/data/factories/ai_provider_factory.dart';
import 'package:deepshield_ai/features/settings/domain/entities/settings.dart';
import 'package:deepshield_ai/features/settings/presentation/providers/settings_provider.dart';

// ---------------------------------------------------------------------------
// Legacy Providers (preserved for backward compatibility)
// ---------------------------------------------------------------------------

/// Provider for the AnalysisLocalDataSource.
final analysisLocalDataSourceProvider = Provider<AnalysisLocalDataSource>(
  (ref) => AnalysisLocalDataSourceImpl(),
);

/// Provider for the AnalysisRepository (now backed by Hive).
final analysisServiceProvider = Provider<AnalysisRepository>(
  (ref) => AnalysisRepositoryImpl(ref.watch(analysisLocalDataSourceProvider)),
);

/// Provider for the MockHistoryRepository.
final historyServiceProvider = Provider<HistoryRepository>(
  (ref) => MockHistoryRepository(),
);

/// Processing step state for the animated processing screen.
class ProcessingState {
  final int currentStep;
  final int totalSteps;
  final String currentLabel;
  final bool isComplete;
  final ScanResultModel? result;

  const ProcessingState({
    this.currentStep = 0,
    this.totalSteps = 5,
    this.currentLabel = 'Preparing...',
    this.isComplete = false,
    this.result,
  });

  double get progress => currentStep / totalSteps;

  ProcessingState copyWith({
    int? currentStep,
    String? currentLabel,
    bool? isComplete,
    ScanResultModel? result,
  }) {
    return ProcessingState(
      currentStep: currentStep ?? this.currentStep,
      totalSteps: totalSteps,
      currentLabel: currentLabel ?? this.currentLabel,
      isComplete: isComplete ?? this.isComplete,
      result: result ?? this.result,
    );
  }
}

/// Manages the analysis processing pipeline.
class AnalysisNotifier extends StateNotifier<ProcessingState> {
  final AnalysisRepository _service;

  AnalysisNotifier(this._service) : super(const ProcessingState());

  /// Run the analysis pipeline for an image.
  Future<ScanResultModel?> analyzeImage(String filePath) async {
    return _runPipeline(() => _service.analyzeMedia(AnalysisRequest(
      filePath: filePath,
      mediaType: 'image',
      fileName: 'image.jpg',
      fileSize: 1024,
      mimeType: 'image/jpeg',
      requestTime: DateTime.now(),
    )));
  }

  /// Run the analysis pipeline for a video.
  Future<ScanResultModel?> analyzeVideo(String filePath) async {
    return _runPipeline(() => _service.analyzeMedia(AnalysisRequest(
      filePath: filePath,
      mediaType: 'video',
      fileName: 'video.mp4',
      fileSize: 1024,
      mimeType: 'video/mp4',
      requestTime: DateTime.now(),
    )));
  }

  Future<ScanResultModel?> _runPipeline(
    Future<dynamic> Function() analyze,
  ) async {
    final steps = [
      'Uploading file...',
      'Detecting faces...',
      'Analyzing artifacts...',
      'Running AI model...',
      'Generating report...',
    ];

    for (int i = 0; i < steps.length; i++) {
      state = state.copyWith(
        currentStep: i + 1,
        currentLabel: steps[i],
      );
      await Future.delayed(const Duration(seconds: 1));
    }

    try {
      await analyze();
      // Temporarily map back to legacy ScanResultModel for the UI
      final legacyResult = ScanResultModel.mockList().first;
      state = state.copyWith(isComplete: true, result: legacyResult);
      return legacyResult;
    } catch (e) {
      return null;
    }
  }

  /// Reset the processing state.
  void reset() {
    state = const ProcessingState();
  }
}

/// Provider for the analysis processing state.
final analysisProvider =
    StateNotifierProvider<AnalysisNotifier, ProcessingState>((ref) {
  return AnalysisNotifier(ref.watch(analysisServiceProvider));
});

/// Provider for scan history.
final scanHistoryProvider = FutureProvider<List<ScanResultModel>>((ref) async {
  final service = ref.watch(historyServiceProvider);
  return service.getScanHistory();
});

// ---------------------------------------------------------------------------
// New Pipeline Providers (Task 7 — Real Processing Pipeline)
// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------

/// Provider for the underlying AI provider implementation.
///
/// Dynamically watches [settingsProvider] and delegates instantiation to
/// [AiProviderFactory], propagating changes through the DI graph instantly.
final aiProviderProvider = Provider<api.AnalysisProvider>((ref) {
  final settings = ref.watch(
    settingsProvider.select((state) => state.settings),
  );
  final isInitialized = ref.watch(
    settingsProvider.select((state) => state.isInitialized),
  );

  if (!isInitialized) {
    return AiProviderFactory.create(Settings.defaults());
  }

  return AiProviderFactory.create(settings);
});

/// Provider for the [AnalysisService] orchestration layer.
///
/// This is the production entry point. When a real [api.AnalysisProvider]
/// is configured, this will automatically wire up the full pipeline.
final analysisServiceCoreProvider = Provider<AnalysisService>((ref) {
  final provider = ref.watch(aiProviderProvider);
  return AnalysisServiceImpl(provider);
});

/// Provider for the real-time pipeline state used by the Processing screen.
///
/// Exposes [AnalysisPipelineState] through an [AnalysisPipelineNotifier]
/// backed by the production [AnalysisService].
final analysisPipelineProvider = StateNotifierProvider<
    AnalysisPipelineNotifier, AnalysisPipelineState>((ref) {
  final service = ref.watch(analysisServiceCoreProvider);
  final repo = ref.watch(analysisServiceProvider);
  return AnalysisPipelineNotifier(service, repo);
});