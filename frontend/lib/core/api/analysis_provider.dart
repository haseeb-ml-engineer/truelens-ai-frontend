import '../utils/result.dart';
import '../../features/analysis/domain/entities/analysis_request.dart';

/// The contract for any underlying AI/LLM inference provider.
///
/// Providers (like Gemini, OpenAI, Claude, or a custom model) must implement
/// this interface. This ensures that the application's core business logic
/// ([AnalysisService]) never depends directly on a specific vendor's SDK or API.
abstract class AnalysisProvider {
  /// Performs the actual media analysis using the provider's backend.
  ///
  /// Takes the generated forensic [prompt] and the [request].
  /// Returns a strongly typed [Result] containing the raw JSON [String] response.
  Future<Result<String>> analyze({
    required AnalysisRequest request,
    required String prompt,
  });

  /// Validates whether the provider supports analyzing the given media.
  ///
  /// e.g. An image-only model would return a Failure if given a video.
  Future<Result<bool>> validateMedia(AnalysisRequest request);

  /// Returns a list of MIME types or file extensions supported by this provider.
  List<String> supportedMediaTypes();

  /// The human-readable name of the provider (e.g. "Google Gemini").
  String providerName();

  /// The specific version of the model being used (e.g. "gemini-2.5-flash").
  String modelVersion();
}
