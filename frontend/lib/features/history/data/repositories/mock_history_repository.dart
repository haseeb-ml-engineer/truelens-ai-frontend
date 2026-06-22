import 'package:deepshield_ai/features/history/domain/repositories/history_repository.dart';
import 'package:deepshield_ai/features/analysis/data/models/scan_result_model.dart';

/// Mock history service.
///
/// Returns cached scan results. Replace with Firestore
/// or PostgreSQL queries later.
class MockHistoryRepository implements HistoryRepository {
  /// Returns all scan history sorted by date.
  @override
  Future<List<ScanResultModel>> getScanHistory() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return ScanResultModel.mockList();
  }

  /// Searches scan history by file name.
  @override
  Future<List<ScanResultModel>> searchScans(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final all = ScanResultModel.mockList();
    if (query.isEmpty) return all;
    return all
        .where((s) => s.fileName.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  /// Filters scans by media type.
  @override
  Future<List<ScanResultModel>> filterByType(MediaType? type) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final all = ScanResultModel.mockList();
    if (type == null) return all;
    return all.where((s) => s.mediaType == type).toList();
  }

  /// Deletes a scan from history.
  @override
  Future<bool> deleteScan(String scanId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }
}