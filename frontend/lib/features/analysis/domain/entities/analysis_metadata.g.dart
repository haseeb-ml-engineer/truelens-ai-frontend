// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analysis_metadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnalysisMetadata _$AnalysisMetadataFromJson(Map<String, dynamic> json) =>
    AnalysisMetadata(
      resolution: json['resolution'] as String?,
      duration: (json['duration'] as num?)?.toDouble(),
      width: (json['width'] as num?)?.toInt(),
      height: (json['height'] as num?)?.toInt(),
      fileExtension: json['fileExtension'] as String?,
      fileHash: json['fileHash'] as String?,
      deviceInformation: json['deviceInformation'] as String?,
    );

Map<String, dynamic> _$AnalysisMetadataToJson(AnalysisMetadata instance) =>
    <String, dynamic>{
      'resolution': instance.resolution,
      'duration': instance.duration,
      'width': instance.width,
      'height': instance.height,
      'fileExtension': instance.fileExtension,
      'fileHash': instance.fileHash,
      'deviceInformation': instance.deviceInformation,
    };
