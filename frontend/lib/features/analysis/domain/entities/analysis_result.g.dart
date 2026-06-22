// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analysis_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnalysisResult _$AnalysisResultFromJson(Map<String, dynamic> json) =>
    AnalysisResult(
      analysisId: json['analysisId'] as String,
      mediaType: json['mediaType'] as String,
      prediction: json['prediction'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      riskScore: (json['riskScore'] as num).toInt(),
      reasoning: json['reasoning'] as String,
      detectedArtifacts: (json['detectedArtifacts'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      recommendations: (json['recommendations'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      processingTime: (json['processingTime'] as num).toInt(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      modelVersion: json['modelVersion'] as String,
      analysisSource: json['analysisSource'] as String,
      technicalDetails: json['technicalDetails'] == null
          ? null
          : TechnicalDetails.fromJson(
              json['technicalDetails'] as Map<String, dynamic>,
            ),
      metadata: json['metadata'] == null
          ? null
          : AnalysisMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
      warnings:
          (json['warnings'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      confidenceBreakdown:
          (json['confidenceBreakdown'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toDouble()),
          ) ??
          const {},
    );

Map<String, dynamic> _$AnalysisResultToJson(AnalysisResult instance) =>
    <String, dynamic>{
      'analysisId': instance.analysisId,
      'mediaType': instance.mediaType,
      'prediction': instance.prediction,
      'confidence': instance.confidence,
      'riskScore': instance.riskScore,
      'reasoning': instance.reasoning,
      'detectedArtifacts': instance.detectedArtifacts,
      'recommendations': instance.recommendations,
      'processingTime': instance.processingTime,
      'timestamp': instance.timestamp.toIso8601String(),
      'modelVersion': instance.modelVersion,
      'analysisSource': instance.analysisSource,
      'technicalDetails': instance.technicalDetails?.toJson(),
      'metadata': instance.metadata?.toJson(),
      'warnings': instance.warnings,
      'confidenceBreakdown': instance.confidenceBreakdown,
    };
