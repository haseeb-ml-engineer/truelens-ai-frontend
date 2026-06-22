import 'prompt_constants.dart';

/// The template used to construct the final prompt sent to the AI provider.
class ForensicPromptTemplate {
  ForensicPromptTemplate._();

  /// Constructs the full forensic prompt by combining the system persona,
  /// analysis directives, media context, and strict formatting rules.
  static String build({
    required String mediaType,
    required String fileName,
    required String mimeType,
    int? fileSize,
    String? metadataContext,
  }) {
    final buffer = StringBuffer();

    // 1. Inject Persona and Rules
    buffer.writeln(PromptConstants.systemPersona);
    buffer.writeln();

    // 2. Media Context
    buffer.writeln('--- MEDIA CONTEXT ---');
    buffer.writeln('Analyzing a $mediaType file.');
    buffer.writeln('Filename: $fileName');
    buffer.writeln('MIME Type: $mimeType');
    if (fileSize != null) {
      buffer.writeln('File Size: $fileSize bytes');
    }
    if (metadataContext != null && metadataContext.isNotEmpty) {
      buffer.writeln('Metadata: $metadataContext');
    }
    buffer.writeln();

    // 3. Analysis Directives
    buffer.writeln('--- ANALYSIS DIRECTIVES ---');
    buffer.writeln(PromptConstants.analysisDirectives);
    if (mediaType.toLowerCase() == 'video') {
      buffer.writeln('CRITICAL: Pay special attention to temporal consistency and frame-level anomalies.');
    } else {
      buffer.writeln('Note: Set temporalConsistency to 0 or omit it for image analysis if inapplicable.');
    }
    buffer.writeln();

    // 4. Output Formatting (Enforcement)
    buffer.writeln('--- OUTPUT FORMAT (STRICT) ---');
    buffer.writeln('You MUST return YOUR ENTIRE RESPONSE exactly matching the following JSON schema.');
    buffer.writeln('Do not include markdown code blocks (e.g., ```json).');
    buffer.writeln('Do not output any leading or trailing text.');
    buffer.writeln();
    buffer.writeln(PromptConstants.jsonSchema);

    return buffer.toString().trim();
  }
}
