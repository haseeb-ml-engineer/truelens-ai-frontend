import '../analysis_provider.dart';
import '../mock_analysis_llm_response.dart';
import '../../utils/result.dart';
import '../../../features/analysis/domain/entities/analysis_request.dart';
import '../../exceptions/app_exceptions.dart';

class ClaudeProvider implements AnalysisProvider {
  final String apiKey;
  
  ClaudeProvider({required this.apiKey});

  @override
  Future<Result<String>> analyze({required AnalysisRequest request, required String prompt}) async {
    if (apiKey.isEmpty) {
      await Future.delayed(const Duration(milliseconds: 900));
      return Success(MockAnalysisLlmResponse.jsonFor(request));
    }
    return Failure(ConfigurationException(message: 'ClaudeProvider logic will be implemented in future tasks.'));
  }

  @override
  Future<Result<bool>> validateMedia(AnalysisRequest request) async {
    return const Success(true);
  }

  @override
  List<String> supportedMediaTypes() => ['image'];

  @override
  String providerName() => 'Anthropic Claude';

  @override
  String modelVersion() => 'claude-3.7-sonnet';
}
