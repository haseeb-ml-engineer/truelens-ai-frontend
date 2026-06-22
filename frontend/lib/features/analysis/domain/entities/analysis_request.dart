import 'package:json_annotation/json_annotation.dart';

part 'analysis_request.g.dart';

/// Immutable domain model representing a request to analyze media.
@JsonSerializable(explicitToJson: true)
class AnalysisRequest {
  /// The local file path to the media.
  final String filePath;

  /// The type of media ('image' or 'video').
  final String mediaType;

  /// The name of the file.
  final String fileName;

  /// The size of the file in bytes.
  final int fileSize;

  /// The MIME type of the file (e.g. 'image/jpeg', 'video/mp4').
  final String mimeType;

  /// The time this request was created.
  final DateTime requestTime;

  const AnalysisRequest({
    required this.filePath,
    required this.mediaType,
    required this.fileName,
    required this.fileSize,
    required this.mimeType,
    required this.requestTime,
  });

  factory AnalysisRequest.fromJson(Map<String, dynamic> json) =>
      _$AnalysisRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AnalysisRequestToJson(this);

  AnalysisRequest copyWith({
    String? filePath,
    String? mediaType,
    String? fileName,
    int? fileSize,
    String? mimeType,
    DateTime? requestTime,
  }) {
    return AnalysisRequest(
      filePath: filePath ?? this.filePath,
      mediaType: mediaType ?? this.mediaType,
      fileName: fileName ?? this.fileName,
      fileSize: fileSize ?? this.fileSize,
      mimeType: mimeType ?? this.mimeType,
      requestTime: requestTime ?? this.requestTime,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnalysisRequest &&
          runtimeType == other.runtimeType &&
          filePath == other.filePath &&
          mediaType == other.mediaType &&
          fileName == other.fileName &&
          fileSize == other.fileSize &&
          mimeType == other.mimeType &&
          requestTime == other.requestTime;

  @override
  int get hashCode =>
      filePath.hashCode ^
      mediaType.hashCode ^
      fileName.hashCode ^
      fileSize.hashCode ^
      mimeType.hashCode ^
      requestTime.hashCode;
}
