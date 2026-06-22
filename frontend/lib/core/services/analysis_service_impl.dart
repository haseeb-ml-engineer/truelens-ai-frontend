import 'dart:async';
import 'analysis_service.dart';
import 'analysis_pipeline.dart';
import '../api/analysis_provider.dart';
import '../utils/result.dart';
import '../exceptions/app_exceptions.dart';
import '../../features/analysis/domain/entities/analysis_request.dart';
import '../../features/analysis/domain/entities/analysis_result.dart';
import '../../features/analysis/domain/entities/analysis_metadata.dart';

/// Production implementation of [AnalysisService].
///
/// Wraps the [AnalysisPipeline] to fulfill the orchestration layer duties.
class AnalysisServiceImpl implements AnalysisService {
  final AnalysisProvider _provider;
  final Map<String, StreamSubscription> _activeTasks = {};

  AnalysisServiceImpl(this._provider);

  @override
  Future<Result<AnalysisResult>> runAnalysis({
    required AnalysisRequest request,
    AnalysisMetadata? metadata,
    void Function(String stage)? onProgress,
  }) async {
    // Generate a unique run ID to allow cancellation
    final runId = request.filePath;
    
    final pipeline = AnalysisPipeline(_provider);

    try {
      final result = await pipeline.execute(
        request: request,
        metadata: metadata,
        onProgress: onProgress,
      );
      
      return result;
    } catch (e) {
      return Failure(UnknownException(
        message: 'A fatal error occurred at the orchestration layer.',
        originalException: e,
      ));
    } finally {
      _activeTasks.remove(runId);
    }
  }

  @override
  void cancelAnalysis(String analysisId) {
    // In a real implementation with Dio CancelTokens, we would signal the 
    // network layer to abort the request.
    _activeTasks[analysisId]?.cancel();
    _activeTasks.remove(analysisId);
  }
}
