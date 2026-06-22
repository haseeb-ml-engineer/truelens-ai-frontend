import '../analysis_provider.dart';
import '../mock_analysis_llm_response.dart';
import '../../utils/result.dart';
import '../../../features/analysis/domain/entities/analysis_request.dart';
import '../../exceptions/app_exceptions.dart';

class GeminiProvider implements AnalysisProvider {
  final String apiKey;
  
  GeminiProvider({required this.apiKey});

  @override
  Future<Result<String>> analyze({required AnalysisRequest request, required String prompt}) async {
    if (apiKey.isEmpty) {
      // MVP fallback: run local mock analysis so the full pipeline completes.
      await Future.delayed(const Duration(milliseconds: 900));
      return Success(MockAnalysisLlmResponse.jsonFor(request));
    }
    return Failure(ConfigurationException(message: 'GeminiProvider logic will be implemented in Task 11.'));
  }

  @override
  Future<Result<bool>> validateMedia(AnalysisRequest request) async {
    return const Success(true);
  }

  @override
  List<String> supportedMediaTypes() => ['image', 'video'];

  @override
  String providerName() => 'Google Gemini';

  @override
  String modelVersion() => 'gemini-3.1-pro';
}
