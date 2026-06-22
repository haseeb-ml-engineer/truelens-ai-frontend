import 'dart:convert';
import '../../domain/entities/analysis_result.dart';

/// A Hive-compatible model that stores essential fields for quick querying,
/// along with the fully serialized [AnalysisResult] to ensure no data loss.
class AnalysisHiveModel {
  final String analysisId;
  final String mediaPath; // Path or thumbnail fallback
  final String mediaType;
  final String prediction;
  final double confidence;
  final int riskScore;
  final DateTime timestamp;
  final int processingTime;
  final String modelVersion;
  final String providerUsed;
  
  /// The complete serialized JSON of the AnalysisResult
  final String serializedResult;

  AnalysisHiveModel({
    required this.analysisId,
    required this.mediaPath,
    required this.mediaType,
    required this.prediction,
    required this.confidence,
    required this.riskScore,
    required this.timestamp,
    required this.processingTime,
    required this.modelVersion,
    required this.providerUsed,
    required this.serializedResult,
  });

  /// Creates a Hive model from a domain entity.
  /// 
  /// The full entity is serialized to JSON to guarantee complete data retention.
  factory AnalysisHiveModel.fromEntity(AnalysisResult entity, {required String mediaPath}) {
    return AnalysisHiveModel(
      analysisId: entity.analysisId,
      mediaPath: mediaPath,
      mediaType: entity.mediaType,
      prediction: entity.prediction,
      confidence: entity.confidence,
      riskScore: entity.riskScore,
      timestamp: entity.timestamp,
      processingTime: entity.processingTime,
      modelVersion: entity.modelVersion,
      providerUsed: entity.analysisSource,
      serializedResult: jsonEncode(entity.toJson()),
    );
  }

  /// Reconstructs the domain entity from the stored JSON.
  AnalysisResult toEntity() {
    final Map<String, dynamic> json = jsonDecode(serializedResult);
    return AnalysisResult.fromJson(json);
  }
}
