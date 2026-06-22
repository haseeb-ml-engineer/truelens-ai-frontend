import '../analysis_provider.dart';
import '../mock_analysis_llm_response.dart';
import '../../utils/result.dart';
import '../../../features/analysis/domain/entities/analysis_request.dart';

class TrueLensProvider implements AnalysisProvider {
  final String apiKey;
  
  TrueLensProvider({this.apiKey = ''});

  @override
  Future<Result<String>> analyze({required AnalysisRequest request, required String prompt}) async {
    await Future.delayed(const Duration(milliseconds: 900));
    return Success(MockAnalysisLlmResponse.jsonFor(request));
  }

  @override
  Future<Result<bool>> validateMedia(AnalysisRequest request) async {
    return const Success(true);
  }

  @override
  List<String> supportedMediaTypes() => ['image', 'video', 'audio'];

  @override
  String providerName() => 'TrueLens AI';

  @override
  String modelVersion() => 'truelens-1.0-alpha';
}
