import '../../features/analysis/domain/entities/analysis_request.dart';
import '../../features/analysis/domain/entities/analysis_metadata.dart';
import 'forensic_prompt_template.dart';
import 'prompt_constants.dart';

/// The builder interface exposed to the application layer.
///
/// Ensures the AI prompt is constructed consistently regardless of the
/// underlying provider (Gemini, OpenAI, Claude).
class PromptBuilder {
  PromptBuilder._();

  /// Builds the complete optimized prompt dynamically based on the request,
  /// media metadata, and the specific provider requirements.
  static String build({
    required AnalysisRequest request,
    AnalysisMetadata? metadata,
    required String providerType,
  }) {
    // 1. Extract context from request
    final mediaType = request.mediaType;
    final fileName = request.fileName;
    final mimeType = request.mimeType;
    final fileSize = request.fileSize;

    // 2. Format optional metadata context
    String? metadataContext;
    if (metadata != null) {
      final metaParts = <String>[];
      if (metadata.resolution != null) metaParts.add('Resolution: ${metadata.resolution}');
      if (metadata.duration != null) metaParts.add('Duration: ${metadata.duration}s');
      if (metadata.deviceInformation != null) metaParts.add('Device: ${metadata.deviceInformation}');
      
      if (metaParts.isNotEmpty) {
        metadataContext = metaParts.join(', ');
      }
    }

    // 3. Generate base prompt
    var finalPrompt = ForensicPromptTemplate.build(
      mediaType: mediaType,
      fileName: fileName,
      mimeType: mimeType,
      fileSize: fileSize,
      metadataContext: metadataContext,
    );

    // 4. Provider-specific optimizations (if necessary)
    // While the schema and rules are identical, some LLMs parse instructions
    // slightly differently. We can append provider-specific nudges here.
    switch (providerType.toLowerCase()) {
      case 'openai':
        finalPrompt += '\n\nIMPORTANT: OpenAI, ensure the response is pure JSON without any ```json wrappers.';
        break;
      case 'claude':
        finalPrompt += '\n\nIMPORTANT: Claude, skip any conversational preamble and output only the raw JSON object.';
        break;
      case 'gemini':
      default:
        // Gemini generally handles the strict template perfectly, but we can reinforce it.
        finalPrompt += '\n\nIMPORTANT: Return ONLY valid JSON matching the schema. No markdown formatting.';
        break;
    }

    return finalPrompt;
  }

  /// Returns the current version of the prompt system for auditing purposes.
  static String get version => PromptConstants.version;
}
