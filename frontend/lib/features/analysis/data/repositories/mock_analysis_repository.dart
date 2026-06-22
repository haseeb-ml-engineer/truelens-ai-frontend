import '../../../../core/utils/result.dart';
import '../../domain/repositories/analysis_repository.dart';
import '../../domain/entities/analysis_result.dart';
import '../../domain/entities/analysis_request.dart';

/// Mock analysis service.
///
/// Simulates the deepfake detection pipeline for development.
class MockAnalysisRepository implements AnalysisRepository {
  @override
  Future<Result<AnalysisResult>> analyzeMedia(AnalysisRequest request) async {
    // Simulate processing steps with delays
    await Future.delayed(const Duration(seconds: 2));

    final mockResult = AnalysisResult(
      analysisId: 'mock_${DateTime.now().millisecondsSinceEpoch}',
      mediaType: request.mediaType,
      prediction: 'authentic',
      confidence: 0.92,
      riskScore: 15,
      reasoning: 'The media exhibits natural lighting and consistent facial features. No significant GAN artifacts or temporal inconsistencies detected.',
      detectedArtifacts: [],
      recommendations: ['Media appears authentic based on current analysis.'],
      processingTime: 2000,
      timestamp: DateTime.now(),
      modelVersion: 'mock-1.0',
      analysisSource: 'mock',
    );

    return Success(mockResult);
  }

  @override
  Future<Result<bool>> saveAnalysis(
    AnalysisResult result, {
    String? mediaPath,
  }) async {
    return const Success(true);
  }

  @override
  Future<Result<List<AnalysisResult>>> getHistory() async {
    return const Success([]);
  }

  @override
  Future<Result<bool>> deleteAnalysis(String analysisId) async {
    return const Success(true);
  }

  @override
  Future<Result<bool>> toggleFavorite(String analysisId) async {
    return const Success(true);
  }

  @override
  Future<Result<List<AnalysisResult>>> searchHistory(String query) async {
    return const Success([]);
  }

  @override
  Future<Result<bool>> clearHistory() async {
    return const Success(true);
  }
}