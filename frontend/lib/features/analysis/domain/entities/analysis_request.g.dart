// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analysis_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnalysisRequest _$AnalysisRequestFromJson(Map<String, dynamic> json) =>
    AnalysisRequest(
      filePath: json['filePath'] as String,
      mediaType: json['mediaType'] as String,
      fileName: json['fileName'] as String,
      fileSize: (json['fileSize'] as num).toInt(),
      mimeType: json['mimeType'] as String,
      requestTime: DateTime.parse(json['requestTime'] as String),
    );

Map<String, dynamic> _$AnalysisRequestToJson(AnalysisRequest instance) =>
    <String, dynamic>{
      'filePath': instance.filePath,
      'mediaType': instance.mediaType,
      'fileName': instance.fileName,
      'fileSize': instance.fileSize,
      'mimeType': instance.mimeType,
      'requestTime': instance.requestTime.toIso8601String(),
    };
