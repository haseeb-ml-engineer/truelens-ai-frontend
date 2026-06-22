import '../../../analysis/domain/entities/analysis_request.dart';

/// Domain entity representing a user-selected media file ready for analysis.
class SelectedMediaFile {
  final String filePath;
  final String fileName;
  final int fileSize;
  final String mimeType;
  final bool isVideo;

  const SelectedMediaFile({
    required this.filePath,
    required this.fileName,
    required this.fileSize,
    required this.mimeType,
    required this.isVideo,
  });

  String get mediaType => isVideo ? 'video' : 'image';

  AnalysisRequest toAnalysisRequest() {
    return AnalysisRequest(
      filePath: filePath,
      mediaType: mediaType,
      fileName: fileName,
      fileSize: fileSize,
      mimeType: mimeType,
      requestTime: DateTime.now(),
    );
  }
}
