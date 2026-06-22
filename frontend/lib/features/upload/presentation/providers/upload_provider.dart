import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/services/media_picker_service.dart';
import '../../domain/entities/selected_media_file.dart';
import '../../../analysis/domain/entities/analysis_request.dart';

/// Provides the shared [MediaPickerService] instance.
final mediaPickerServiceProvider = Provider<MediaPickerService>(
  (ref) => MediaPickerService(),
);

/// Holds the currently selected media file for upload/analysis.
final uploadProvider =
    StateNotifierProvider<UploadNotifier, SelectedMediaFile?>(
  (ref) => UploadNotifier(ref.read(mediaPickerServiceProvider)),
);

/// Manages selected upload state and bridges to [AnalysisRequest].
class UploadNotifier extends StateNotifier<SelectedMediaFile?> {
  UploadNotifier(this._pickerService) : super(null);

  final MediaPickerService _pickerService;

  Future<void> pickImage() async {
    final file = await _pickerService.pickImage();
    if (file != null) {
      state = file;
    }
  }

  Future<void> pickVideo() async {
    final file = await _pickerService.pickVideo();
    if (file != null) {
      state = file;
    }
  }

  void clearSelection() => state = null;

  AnalysisRequest? buildAnalysisRequest() => state?.toAnalysisRequest();
}
