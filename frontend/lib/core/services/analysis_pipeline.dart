import 'dart:convert';
import 'dart:async';
import '../api/analysis_provider.dart';
import '../prompts/prompt_builder.dart';
import '../utils/result.dart';
import '../exceptions/app_exceptions.dart';
import '../../features/analysis/domain/entities/analysis_request.dart';
import '../../features/analysis/domain/entities/analysis_result.dart';
import '../../features/analysis/domain/entities/analysis_metadata.dart';

/// Implements the step-by-step processing pipeline for forensic analysis.
class AnalysisPipeline {
  final AnalysisProvider _provider;

  AnalysisPipeline(this._provider);

  /// Executes the orchestrated analysis pipeline.
  Future<Result<AnalysisResult>> execute({
    required AnalysisRequest request,
    AnalysisMetadata? metadata,
    void Function(String stage)? onProgress,
  }) async {
    final startTime = DateTime.now();

    try {
      // Step 1: Validation
      onProgress?.call('Validating media...');
      final validationResult = await _provider.validateMedia(request);
      if (validationResult is Failure<bool>) {
        return Failure(validationResult.error);
      }
      if (validationResult is Success<bool> && !validationResult.data) {
        return Failure(ValidationException(
          message: 'Media type not supported by ${_provider.providerName()}',
        ));
      }

      // Step 2: Prompt Generation
      onProgress?.call('Generating forensic prompt...');
      final prompt = PromptBuilder.build(
        request: request,
        metadata: metadata,
        providerType: _provider.providerName(),
      );

      // Step 3: Execution
      onProgress?.call('Running AI analysis...');
      final rawResponseResult = await _provider.analyze(
        request: request,
        prompt: prompt,
      );

      if (rawResponseResult is Failure<String>) {
        return Failure(rawResponseResult.error);
      }

      final rawJsonString = (rawResponseResult as Success<String>).data;

      // Step 4: JSON Validation & Parsing
      onProgress?.call('Parsing and validating results...');
      final parsedResult = _parseAndValidate(rawJsonString, request, startTime);

      // Step 5: Finalization
      onProgress?.call('Analysis complete.');
      return Success(parsedResult);
    } catch (e, stackTrace) {
      if (e is AppException) {
        return Failure(e);
      }
      return Failure(UnknownException(
        message: 'An unexpected error occurred during analysis.',
        originalException: e,
        stackTrace: stackTrace,
      ));
    }
  }

  /// Parses the raw JSON string and safely constructs an [AnalysisResult].
  AnalysisResult _parseAndValidate(
    String rawJsonString,
    AnalysisRequest request,
    DateTime startTime,
  ) {
    try {
      // Sometimes LLMs wrap JSON in markdown blocks (e.g., ```json ... ```)
      // despite explicit instructions. Strip them if present.
      final cleanJsonString = _stripMarkdown(rawJsonString);
      
      final Map<String, dynamic> jsonMap = jsonDecode(cleanJsonString);

      // Ensure mandatory fields exist (basic validation)
      if (!jsonMap.containsKey('prediction') || !jsonMap.containsKey('confidence')) {
        throw JsonParsingException(
          message: 'AI response is missing critical fields (prediction/confidence).',
          technicalDetails: 'Raw output: $cleanJsonString',
        );
      }

      final processingTime = DateTime.now().difference(startTime).inMilliseconds;

      return AnalysisResult.fromJson({
        'analysisId': 'scan_${DateTime.now().millisecondsSinceEpoch}',
        'mediaType': request.mediaType,
        'processingTime': processingTime,
        'timestamp': DateTime.now().toIso8601String(),
        'modelVersion': _provider.modelVersion(),
        'analysisSource': _provider.providerName(),
        ...jsonMap, // Merge AI output
      });
    } catch (e) {
      if (e is JsonParsingException) rethrow;
      throw JsonParsingException(
        message: 'Failed to parse AI response into structured forensic data.',
        originalException: e,
      );
    }
  }

  String _stripMarkdown(String input) {
    var text = input.trim();
    if (text.startsWith('```json')) {
      text = text.replaceFirst('```json', '');
    } else if (text.startsWith('```')) {
      text = text.replaceFirst('```', '');
    }
    if (text.endsWith('```')) {
      text = text.substring(0, text.length - 3);
    }
    return text.trim();
  }
}
