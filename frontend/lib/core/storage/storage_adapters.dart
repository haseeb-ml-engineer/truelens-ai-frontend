import 'package:hive/hive.dart';
import '../../features/analysis/data/models/analysis_hive_model.dart';
import 'storage_keys.dart';

/// A manual Hive TypeAdapter for [AnalysisHiveModel].
/// 
/// This avoids the need for build_runner/code-gen, keeping the build process 
/// extremely fast and stable, while robustly saving all properties to disk.
class AnalysisHiveModelAdapter extends TypeAdapter<AnalysisHiveModel> {
  @override
  final int typeId = StorageKeys.typeIdAnalysisHiveModel;

  @override
  AnalysisHiveModel read(BinaryReader reader) {
    return AnalysisHiveModel(
      analysisId: reader.readString(),
      mediaPath: reader.readString(),
      mediaType: reader.readString(),
      prediction: reader.readString(),
      confidence: reader.readDouble(),
      riskScore: reader.readInt(),
      timestamp: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
      processingTime: reader.readInt(),
      modelVersion: reader.readString(),
      providerUsed: reader.readString(),
      serializedResult: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, AnalysisHiveModel obj) {
    writer.writeString(obj.analysisId);
    writer.writeString(obj.mediaPath);
    writer.writeString(obj.mediaType);
    writer.writeString(obj.prediction);
    writer.writeDouble(obj.confidence);
    writer.writeInt(obj.riskScore);
    writer.writeInt(obj.timestamp.millisecondsSinceEpoch);
    writer.writeInt(obj.processingTime);
    writer.writeString(obj.modelVersion);
    writer.writeString(obj.providerUsed);
    writer.writeString(obj.serializedResult);
  }
}
