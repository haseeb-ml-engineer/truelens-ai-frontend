import 'dart:async';
import '../utils/result.dart';
import '../../features/analysis/domain/entities/analysis_request.dart';
import '../../features/analysis/domain/entities/analysis_result.dart';
import '../../features/analysis/domain/entities/analysis_metadata.dart';

/// The core AI Orchestration Layer for TrueLens AI.
///
/// This service acts as the SINGLE entry point for all AI analysis operations.
/// It must be provider-agnostic and fully independent of UI and Network layers.
abstract class AnalysisService {
  /// Orchestrates the full analysis pipeline:
  /// 1. Validates input
  /// 2. Generates forensic prompt
  /// 3. Executes AI provider analysis
  /// 4. Parses and validates raw JSON
  /// 5. Wraps output in [Result]
  Future<Result<AnalysisResult>> runAnalysis({
    required AnalysisRequest request,
    AnalysisMetadata? metadata,
    void Function(String stage)? onProgress,
  });

  /// Cancels an ongoing analysis operation if supported by the provider.
  void cancelAnalysis(String analysisId);
}
