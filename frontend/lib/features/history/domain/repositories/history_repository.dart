import 'package:deepshield_ai/features/analysis/data/models/scan_result_model.dart';

abstract class HistoryRepository {
  Future<List<ScanResultModel>> getScanHistory();
  Future<List<ScanResultModel>> searchScans(String query);
  Future<List<ScanResultModel>> filterByType(MediaType? type);
  Future<bool> deleteScan(String scanId);
}
