import '../../../../core/utils/result.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../domain/entities/analysis_request.dart';
import '../../domain/entities/analysis_result.dart';
import '../../domain/repositories/analysis_repository.dart';
import '../datasources/analysis_local_datasource.dart';
import '../models/analysis_hive_model.dart';

/// The production implementation of [AnalysisRepository].
/// 
/// It connects the local data source (Hive) to the core application, wrapping
/// all operations in [Result] to prevent unhandled exceptions.
class AnalysisRepositoryImpl implements AnalysisRepository {
  final AnalysisLocalDataSource _localDataSource;

  AnalysisRepositoryImpl(this._localDataSource);

  @override
  Future<Result<AnalysisResult>> analyzeMedia(AnalysisRequest request) async {
    // Note: this repository is primarily for storage/history. 
    // The actual analysis execution happens in AnalysisPipeline/AnalysisService.
    return Failure(ConfigurationException(technicalDetails: 'Analysis flow is managed by AnalysisService.'));
  }

  @override
  Future<Result<bool>> saveAnalysis(
    AnalysisResult result, {
    String? mediaPath,
  }) async {
    try {
      final model = AnalysisHiveModel.fromEntity(
        result,
        mediaPath: mediaPath ?? 'local_path',
      );
      await _localDataSource.saveAnalysis(model);
      return const Success(true);
    } catch (e) {
      if (e is AppException) return Failure(e);
      return Failure(StorageException(technicalDetails: 'Unexpected error saving analysis: $e'));
    }
  }

  @override
  Future<Result<List<AnalysisResult>>> getHistory() async {
    try {
      final models = await _localDataSource.getAllAnalyses();
      final entities = models.map((m) => m.toEntity()).toList();
      return Success(entities);
    } catch (e) {
      if (e is AppException) return Failure(e);
      return Failure(StorageException(technicalDetails: 'Unexpected error loading history: $e'));
    }
  }

  @override
  Future<Result<bool>> deleteAnalysis(String analysisId) async {
    try {
      await _localDataSource.deleteAnalysis(analysisId);
      return const Success(true);
    } catch (e) {
      if (e is AppException) return Failure(e);
      return Failure(StorageException(technicalDetails: 'Unexpected error deleting analysis: $e'));
    }
  }

  @override
  Future<Result<bool>> clearHistory() async {
    try {
      await _localDataSource.clearAll();
      return const Success(true);
    } catch (e) {
      if (e is AppException) return Failure(e);
      return Failure(StorageException(technicalDetails: 'Unexpected error clearing history: $e'));
    }
  }

  @override
  Future<Result<bool>> toggleFavorite(String analysisId) async {
    // MVP implementation: returning false.
    // To support favorites properly we would add an isFavorite flag to the Hive model.
    return const Success(false);
  }

  @override
  Future<Result<List<AnalysisResult>>> searchHistory(String query) async {
    try {
      final models = await _localDataSource.getAllAnalyses();
      final entities = models.map((m) => m.toEntity()).where((e) {
        final searchTarget = '\${e.prediction} \${e.reasoning} \${e.mediaType}'.toLowerCase();
        return searchTarget.contains(query.toLowerCase());
      }).toList();
      return Success(entities);
    } catch (e) {
      if (e is AppException) return Failure(e);
      return Failure(StorageException(technicalDetails: 'Unexpected error searching history: $e'));
    }
  }
}
