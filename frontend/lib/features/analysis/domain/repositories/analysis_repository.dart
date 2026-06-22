import '../../../../core/utils/result.dart';
import '../entities/analysis_request.dart';
import '../entities/analysis_result.dart';

/// The contract for the analysis data layer.
///
/// This defines the operations the application can perform, abstracting away
/// whether the data comes from a local mock, a live AI provider, or local storage.
abstract class AnalysisRepository {
  /// Analyzes the given media file.
  ///
  /// Takes an [AnalysisRequest] containing the file metadata and returns a
  /// [Result] encapsulating either an [AnalysisResult] on success or an
  /// `AppException` on failure.
  Future<Result<AnalysisResult>> analyzeMedia(AnalysisRequest request);

  /// Saves an analysis result to local storage for historical access.
  ///
  /// Returns a [Result] containing `true` if successful.
  Future<Result<bool>> saveAnalysis(
    AnalysisResult result, {
    String? mediaPath,
  });

  /// Retrieves the history of saved analyses.
  ///
  /// Returns a list of [AnalysisResult] objects wrapped in a [Result].
  Future<Result<List<AnalysisResult>>> getHistory();

  /// Deletes a specific analysis from history by its [analysisId].
  ///
  /// Returns a [Result] containing `true` if successful.
  Future<Result<bool>> deleteAnalysis(String analysisId);

  /// Toggles the favorite status of a specific analysis.
  ///
  /// Returns a [Result] containing the new favorite status `true`/`false`.
  Future<Result<bool>> toggleFavorite(String analysisId);

  /// Searches the analysis history based on a provided [query].
  ///
  /// Returns a filtered list of [AnalysisResult] objects wrapped in a [Result].
  Future<Result<List<AnalysisResult>>> searchHistory(String query);

  /// Clears all analysis records from local storage.
  ///
  /// Returns a [Result] containing `true` if successful.
  Future<Result<bool>> clearHistory();
}
