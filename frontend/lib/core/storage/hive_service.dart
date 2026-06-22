import 'package:hive_flutter/hive_flutter.dart';
import 'storage_keys.dart';
import 'storage_adapters.dart';
import '../config/settings_config.dart';
import '../../features/analysis/data/models/analysis_hive_model.dart';

/// A core service to initialize and manage the Hive database.
class HiveService {
  HiveService._();

  /// Initializes Hive, registers manual TypeAdapters, and opens required boxes.
  /// 
  /// Must be called in `main.dart` before `runApp()`.
  static Future<void> init() async {
    // Initialize Hive for Flutter
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(StorageKeys.typeIdAnalysisHiveModel)) {
      Hive.registerAdapter(AnalysisHiveModelAdapter());
    }

    // Open boxes
    await Hive.openBox<AnalysisHiveModel>(StorageKeys.analysisHistoryBox);
    await Hive.openBox(SettingsConfig.settingsBox);
  }

  /// Returns the box containing analysis history.
  static Box<AnalysisHiveModel> getAnalysisBox() {
    return Hive.box<AnalysisHiveModel>(StorageKeys.analysisHistoryBox);
  }

  /// Returns the box containing application settings.
  static Box getSettingsBox() {
    return Hive.box(SettingsConfig.settingsBox);
  }

  /// Clears all analysis history entries.
  static Future<void> clearHistory() async {
    final box = getAnalysisBox();
    await box.clear();
  }
}
