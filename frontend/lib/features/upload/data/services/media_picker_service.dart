import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/config/app_config.dart';
import '../../domain/entities/selected_media_file.dart';

/// Handles native file selection for images and videos.
class MediaPickerService {
  MediaPickerService({ImagePicker? imagePicker})
      : _imagePicker = imagePicker ?? ImagePicker();

  final ImagePicker _imagePicker;

  /// Opens the gallery picker for a still image.
  Future<SelectedMediaFile?> pickImage() async {
    final picked = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (picked == null) return null;

    return _fromPath(picked.path, isVideo: false);
  }

  /// Opens the system file picker for a video file.
  Future<SelectedMediaFile?> pickVideo() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: AppConfig.supportedVideoFormats,
      allowMultiple: false,
      withData: false,
    );

    if (result == null || result.files.isEmpty) return null;

    final platformFile = result.files.single;
    final path = platformFile.path;
    if (path == null) return null;

    return _fromPath(path, isVideo: true);
  }

  SelectedMediaFile? _fromPath(String path, {required bool isVideo}) {
    final file = File(path);
    if (!file.existsSync()) return null;

    final fileSize = file.lengthSync();
    if (fileSize > AppConfig.maxUploadSizeBytes) {
      throw MediaPickerException(
        'File exceeds the ${AppConfig.maxUploadSizeBytes ~/ (1024 * 1024)} MB limit.',
      );
    }

    final fileName = path.split(Platform.pathSeparator).last;
    return SelectedMediaFile(
      filePath: path,
      fileName: fileName,
      fileSize: fileSize,
      mimeType: _mimeTypeForPath(path, isVideo: isVideo),
      isVideo: isVideo,
    );
  }

  String _mimeTypeForPath(String path, {required bool isVideo}) {
    final extension = path.split('.').last.toLowerCase();
    if (isVideo) {
      switch (extension) {
        case 'mp4':
          return 'video/mp4';
        case 'mov':
          return 'video/quicktime';
        case 'avi':
          return 'video/x-msvideo';
        case 'mkv':
          return 'video/x-matroska';
        default:
          return 'video/mp4';
      }
    }

    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      case 'bmp':
        return 'image/bmp';
      default:
        return 'image/jpeg';
    }
  }
}

/// Thrown when file selection or validation fails.
class MediaPickerException implements Exception {
  final String message;

  const MediaPickerException(this.message);

  @override
  String toString() => message;
}
