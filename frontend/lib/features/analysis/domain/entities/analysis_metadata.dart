import 'package:json_annotation/json_annotation.dart';

part 'analysis_metadata.g.dart';

/// Immutable domain model representing the metadata of the media being analyzed.
@JsonSerializable(explicitToJson: true)
class AnalysisMetadata {
  /// The resolution of the media (e.g., "1920x1080").
  final String? resolution;

  /// The duration of the media in seconds (applicable for video).
  final double? duration;

  /// The width of the media in pixels.
  final int? width;

  /// The height of the media in pixels.
  final int? height;

  /// The file extension (e.g., "jpg", "mp4").
  final String? fileExtension;

  /// A cryptographic hash of the file contents to detect duplicates.
  final String? fileHash;

  /// Information about the device that captured or processed the media (from EXIF).
  final String? deviceInformation;

  const AnalysisMetadata({
    this.resolution,
    this.duration,
    this.width,
    this.height,
    this.fileExtension,
    this.fileHash,
    this.deviceInformation,
  });

  factory AnalysisMetadata.fromJson(Map<String, dynamic> json) =>
      _$AnalysisMetadataFromJson(json);

  Map<String, dynamic> toJson() => _$AnalysisMetadataToJson(this);

  AnalysisMetadata copyWith({
    String? resolution,
    double? duration,
    int? width,
    int? height,
    String? fileExtension,
    String? fileHash,
    String? deviceInformation,
  }) {
    return AnalysisMetadata(
      resolution: resolution ?? this.resolution,
      duration: duration ?? this.duration,
      width: width ?? this.width,
      height: height ?? this.height,
      fileExtension: fileExtension ?? this.fileExtension,
      fileHash: fileHash ?? this.fileHash,
      deviceInformation: deviceInformation ?? this.deviceInformation,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnalysisMetadata &&
          runtimeType == other.runtimeType &&
          resolution == other.resolution &&
          duration == other.duration &&
          width == other.width &&
          height == other.height &&
          fileExtension == other.fileExtension &&
          fileHash == other.fileHash &&
          deviceInformation == other.deviceInformation;

  @override
  int get hashCode =>
      resolution.hashCode ^
      duration.hashCode ^
      width.hashCode ^
      height.hashCode ^
      fileExtension.hashCode ^
      fileHash.hashCode ^
      deviceInformation.hashCode;
}
