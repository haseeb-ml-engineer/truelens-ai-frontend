import 'package:json_annotation/json_annotation.dart';

part 'technical_details.g.dart';

/// Immutable domain model representing granular technical and forensic details
/// of an analysis.
///
/// Designed to be populated later by the TrueLens AI model, but also gracefully
/// handles sparse data from LLM-based providers in the MVP.
@JsonSerializable(explicitToJson: true)
class TechnicalDetails {
  /// Score indicating the likelihood of GAN (Generative Adversarial Network) generation.
  final double? ganFingerprintScore;

  /// Score indicating consistency of lighting across the media.
  final double? lightingConsistency;

  /// Score indicating consistency of facial features.
  final double? facialConsistency;

  /// Score indicating symmetry of the subject's eyes.
  final double? eyeSymmetry;

  /// Score indicating the naturalness of textures (skin, background).
  final double? textureConsistency;

  /// Analysis of compression artifacts (often disrupted by deepfake generation).
  final double? compressionAnalysis;

  /// Consistency between sequential frames (applicable only for video).
  final double? frameConsistency;

  /// Integrity of the file's EXIF or internal metadata.
  final double? metadataIntegrity;

  /// Overall probability that manipulation techniques were detected.
  final double? manipulationProbability;

  const TechnicalDetails({
    this.ganFingerprintScore,
    this.lightingConsistency,
    this.facialConsistency,
    this.eyeSymmetry,
    this.textureConsistency,
    this.compressionAnalysis,
    this.frameConsistency,
    this.metadataIntegrity,
    this.manipulationProbability,
  });

  factory TechnicalDetails.fromJson(Map<String, dynamic> json) =>
      _$TechnicalDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$TechnicalDetailsToJson(this);

  TechnicalDetails copyWith({
    double? ganFingerprintScore,
    double? lightingConsistency,
    double? facialConsistency,
    double? eyeSymmetry,
    double? textureConsistency,
    double? compressionAnalysis,
    double? frameConsistency,
    double? metadataIntegrity,
    double? manipulationProbability,
  }) {
    return TechnicalDetails(
      ganFingerprintScore: ganFingerprintScore ?? this.ganFingerprintScore,
      lightingConsistency: lightingConsistency ?? this.lightingConsistency,
      facialConsistency: facialConsistency ?? this.facialConsistency,
      eyeSymmetry: eyeSymmetry ?? this.eyeSymmetry,
      textureConsistency: textureConsistency ?? this.textureConsistency,
      compressionAnalysis: compressionAnalysis ?? this.compressionAnalysis,
      frameConsistency: frameConsistency ?? this.frameConsistency,
      metadataIntegrity: metadataIntegrity ?? this.metadataIntegrity,
      manipulationProbability: manipulationProbability ?? this.manipulationProbability,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TechnicalDetails &&
          runtimeType == other.runtimeType &&
          ganFingerprintScore == other.ganFingerprintScore &&
          lightingConsistency == other.lightingConsistency &&
          facialConsistency == other.facialConsistency &&
          eyeSymmetry == other.eyeSymmetry &&
          textureConsistency == other.textureConsistency &&
          compressionAnalysis == other.compressionAnalysis &&
          frameConsistency == other.frameConsistency &&
          metadataIntegrity == other.metadataIntegrity &&
          manipulationProbability == other.manipulationProbability;

  @override
  int get hashCode =>
      ganFingerprintScore.hashCode ^
      lightingConsistency.hashCode ^
      facialConsistency.hashCode ^
      eyeSymmetry.hashCode ^
      textureConsistency.hashCode ^
      compressionAnalysis.hashCode ^
      frameConsistency.hashCode ^
      metadataIntegrity.hashCode ^
      manipulationProbability.hashCode;
}
