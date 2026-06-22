// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'technical_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TechnicalDetails _$TechnicalDetailsFromJson(Map<String, dynamic> json) =>
    TechnicalDetails(
      ganFingerprintScore: (json['ganFingerprintScore'] as num?)?.toDouble(),
      lightingConsistency: (json['lightingConsistency'] as num?)?.toDouble(),
      facialConsistency: (json['facialConsistency'] as num?)?.toDouble(),
      eyeSymmetry: (json['eyeSymmetry'] as num?)?.toDouble(),
      textureConsistency: (json['textureConsistency'] as num?)?.toDouble(),
      compressionAnalysis: (json['compressionAnalysis'] as num?)?.toDouble(),
      frameConsistency: (json['frameConsistency'] as num?)?.toDouble(),
      metadataIntegrity: (json['metadataIntegrity'] as num?)?.toDouble(),
      manipulationProbability: (json['manipulationProbability'] as num?)
          ?.toDouble(),
    );

Map<String, dynamic> _$TechnicalDetailsToJson(TechnicalDetails instance) =>
    <String, dynamic>{
      'ganFingerprintScore': instance.ganFingerprintScore,
      'lightingConsistency': instance.lightingConsistency,
      'facialConsistency': instance.facialConsistency,
      'eyeSymmetry': instance.eyeSymmetry,
      'textureConsistency': instance.textureConsistency,
      'compressionAnalysis': instance.compressionAnalysis,
      'frameConsistency': instance.frameConsistency,
      'metadataIntegrity': instance.metadataIntegrity,
      'manipulationProbability': instance.manipulationProbability,
    };
