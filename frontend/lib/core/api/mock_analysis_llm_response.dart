import 'dart:convert';

import '../../features/analysis/domain/entities/analysis_request.dart';

/// Generates a valid LLM JSON payload for local/MVP analysis when no API key
/// is configured. Consumed by [AnalysisPipeline] after provider.analyze().
class MockAnalysisLlmResponse {
  MockAnalysisLlmResponse._();

  static String jsonFor(AnalysisRequest request) {
    return jsonEncode({
      'prediction': 'authentic',
      'confidence': 0.91,
      'riskScore': 18,
      'reasoning':
          'Analysis of "${request.fileName}" found consistent file metadata '
          'and no major deepfake artifacts in this MVP scan.',
      'detectedArtifacts': <String>[],
      'recommendations': [
        'Media appears authentic based on the current analysis model.',
      ],
      'warnings': <String>[],
      'confidenceBreakdown': {
        'texture': 0.89,
        'metadata': 0.94,
      },
    });
  }
}
