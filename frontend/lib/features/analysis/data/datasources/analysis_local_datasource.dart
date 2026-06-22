import 'package:hive_flutter/hive_flutter.dart';
import '../models/analysis_hive_model.dart';
import '../../../../core/storage/hive_service.dart';
import '../../../../core/exceptions/app_exceptions.dart';

abstract class AnalysisLocalDataSource {
  Future<void> saveAnalysis(AnalysisHiveModel model);
  Future<List<AnalysisHiveModel>> getAllAnalyses();
  Future<void> deleteAnalysis(String id);
  Future<void> clearAll();
}

class AnalysisLocalDataSourceImpl implements AnalysisLocalDataSource {
  Box<AnalysisHiveModel> get _box => HiveService.getAnalysisBox();

  @override
  Future<void> saveAnalysis(AnalysisHiveModel model) async {
    try {
      await _box.put(model.analysisId, model);
    } catch (e) {
      throw StorageException(technicalDetails: 'Failed to save analysis to disk: $e');
    }
  }

  @override
  Future<List<AnalysisHiveModel>> getAllAnalyses() async {
    try {
      // Return list sorted by timestamp descending (newest first)
      final analyses = _box.values.toList();
      analyses.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return analyses;
    } catch (e) {
      throw StorageException(technicalDetails: 'Failed to read analyses from disk: $e');
    }
  }

  @override
  Future<void> deleteAnalysis(String id) async {
    try {
      await _box.delete(id);
    } catch (e) {
      throw StorageException(technicalDetails: 'Failed to delete analysis: $e');
    }
  }

  @override
  Future<void> clearAll() async {
    try {
      await _box.clear();
    } catch (e) {
      throw StorageException(technicalDetails: 'Failed to clear history: $e');
    }
  }
}
