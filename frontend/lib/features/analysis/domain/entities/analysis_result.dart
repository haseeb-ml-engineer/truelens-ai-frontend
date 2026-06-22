import 'package:json_annotation/json_annotation.dart';

import 'analysis_metadata.dart';
import 'technical_details.dart';

part 'analysis_result.g.dart';

/// Immutable domain model representing the complete result of a media analysis.
///
/// This serves as the single source of truth for the UI (ResultsScreen, HistoryScreen)
/// and is independent of the underlying AI provider (Gemini, OpenAI, Claude, TrueLens AI).
@JsonSerializable(explicitToJson: true)
class AnalysisResult {
  /// Unique identifier for this analysis scan.
  final String analysisId;

  /// The type of media analyzed ('image' or 'video').
  final String mediaType;

  /// The categorical prediction ('authentic', 'manipulated', 'uncertain').
  final String prediction;

  /// The confidence score of the prediction (0.0 to 1.0).
  final double confidence;

  /// The overall risk score (0 to 100).
  final int riskScore;

  /// Human-readable explanation of the AI's reasoning.
  final String reasoning;

  /// List of specific manipulation artifacts detected.
  final List<String> detectedArtifacts;

  /// List of actionable recommendations for the user based on the findings.
  final List<String> recommendations;

  /// The time taken by the AI provider to process the request, in milliseconds.
  final int processingTime;

  /// The exact time the analysis was completed.
  final DateTime timestamp;

  /// The version of the model that performed the analysis.
  final String modelVersion;

  /// The AI provider that performed the analysis (e.g., 'gemini', 'openai').
  final String analysisSource;

  /// In-depth forensic details (often populated by specialized models).
  final TechnicalDetails? technicalDetails;

  /// Information about the analyzed file.
  final AnalysisMetadata? metadata;

  /// Any warnings generated during analysis (e.g., "Low resolution image").
  final List<String> warnings;

  /// A breakdown of confidence across different categories.
  final Map<String, double> confidenceBreakdown;

  const AnalysisResult({
    required this.analysisId,
    required this.mediaType,
    required this.prediction,
    required this.confidence,
    required this.riskScore,
    required this.reasoning,
    required this.detectedArtifacts,
    required this.recommendations,
    required this.processingTime,
    required this.timestamp,
    required this.modelVersion,
    required this.analysisSource,
    this.technicalDetails,
    this.metadata,
    this.warnings = const [],
    this.confidenceBreakdown = const {},
  });

  factory AnalysisResult.fromJson(Map<String, dynamic> json) =>
      _$AnalysisResultFromJson(json);

  Map<String, dynamic> toJson() => _$AnalysisResultToJson(this);

  AnalysisResult copyWith({
    String? analysisId,
    String? mediaType,
    String? prediction,
    double? confidence,
    int? riskScore,
    String? reasoning,
    List<String>? detectedArtifacts,
    List<String>? recommendations,
    int? processingTime,
    DateTime? timestamp,
    String? modelVersion,
    String? analysisSource,
    TechnicalDetails? technicalDetails,
    AnalysisMetadata? metadata,
    List<String>? warnings,
    Map<String, double>? confidenceBreakdown,
  }) {
    return AnalysisResult(
      analysisId: analysisId ?? this.analysisId,
      mediaType: mediaType ?? this.mediaType,
      prediction: prediction ?? this.prediction,
      confidence: confidence ?? this.confidence,
      riskScore: riskScore ?? this.riskScore,
      reasoning: reasoning ?? this.reasoning,
      detectedArtifacts: detectedArtifacts ?? this.detectedArtifacts,
      recommendations: recommendations ?? this.recommendations,
      processingTime: processingTime ?? this.processingTime,
      timestamp: timestamp ?? this.timestamp,
      modelVersion: modelVersion ?? this.modelVersion,
      analysisSource: analysisSource ?? this.analysisSource,
      technicalDetails: technicalDetails ?? this.technicalDetails,
      metadata: metadata ?? this.metadata,
      warnings: warnings ?? this.warnings,
      confidenceBreakdown: confidenceBreakdown ?? this.confidenceBreakdown,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AnalysisResult &&
        other.analysisId == analysisId &&
        other.mediaType == mediaType &&
        other.prediction == prediction &&
        other.confidence == confidence &&
        other.riskScore == riskScore &&
        other.reasoning == reasoning &&
        _listEquals(other.detectedArtifacts, detectedArtifacts) &&
        _listEquals(other.recommendations, recommendations) &&
        other.processingTime == processingTime &&
        other.timestamp == timestamp &&
        other.modelVersion == modelVersion &&
        other.analysisSource == analysisSource &&
        other.technicalDetails == technicalDetails &&
        other.metadata == metadata &&
        _listEquals(other.warnings, warnings) &&
        _mapEquals(other.confidenceBreakdown, confidenceBreakdown);
  }

  @override
  int get hashCode {
    return analysisId.hashCode ^
        mediaType.hashCode ^
        prediction.hashCode ^
        confidence.hashCode ^
        riskScore.hashCode ^
        reasoning.hashCode ^
        Object.hashAll(detectedArtifacts) ^
        Object.hashAll(recommendations) ^
        processingTime.hashCode ^
        timestamp.hashCode ^
        modelVersion.hashCode ^
        analysisSource.hashCode ^
        technicalDetails.hashCode ^
        metadata.hashCode ^
        Object.hashAll(warnings) ^
        _mapHashCode(confidenceBreakdown);
  }

  // Helper for deep list equality
  bool _listEquals<E>(List<E>? list1, List<E>? list2) {
    if (identical(list1, list2)) return true;
    if (list1 == null || list2 == null) return false;
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) return false;
    }
    return true;
  }

  // Helper for deep map equality
  bool _mapEquals<K, V>(Map<K, V>? map1, Map<K, V>? map2) {
    if (identical(map1, map2)) return true;
    if (map1 == null || map2 == null) return false;
    if (map1.length != map2.length) return false;
    for (final key in map1.keys) {
      if (!map2.containsKey(key) || map1[key] != map2[key]) return false;
    }
    return true;
  }

  // Helper for map hashcode
  int _mapHashCode(Map map) {
    int result = 0;
    for (final key in map.keys) {
      result ^= key.hashCode ^ map[key].hashCode;
    }
    return result;
  }
}
