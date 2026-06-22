import 'dart:io';

import 'package:deepshield_ai/core/config/settings_config.dart';
import 'package:deepshield_ai/core/storage/storage_adapters.dart';
import 'package:deepshield_ai/core/storage/storage_keys.dart';
import 'package:deepshield_ai/core/utils/result.dart';
import 'package:deepshield_ai/features/analysis/data/datasources/analysis_local_datasource.dart';
import 'package:deepshield_ai/features/analysis/data/models/analysis_hive_model.dart';
import 'package:deepshield_ai/features/analysis/data/repositories/analysis_repository_impl.dart';
import 'package:deepshield_ai/features/analysis/domain/entities/analysis_result.dart';
import 'package:deepshield_ai/features/settings/data/datasources/settings_local_datasource.dart';
import 'package:deepshield_ai/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:deepshield_ai/features/settings/domain/entities/settings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

void main() {
  late AnalysisLocalDataSourceImpl historyDataSource;
  late AnalysisRepositoryImpl historyRepository;
  late SettingsLocalDataSourceImpl settingsDataSource;
  late SettingsRepositoryImpl settingsRepository;

  setUpAll(() async {
    final tempDir = await Directory.systemTemp.createTemp('deepshield_hive_test');
    Hive.init(tempDir.path);

    if (!Hive.isAdapterRegistered(StorageKeys.typeIdAnalysisHiveModel)) {
      Hive.registerAdapter(AnalysisHiveModelAdapter());
    }

    await Hive.openBox<AnalysisHiveModel>(StorageKeys.analysisHistoryBox);
    await Hive.openBox(SettingsConfig.settingsBox);
  });

  setUp(() async {
    historyDataSource = AnalysisLocalDataSourceImpl();
    historyRepository = AnalysisRepositoryImpl(historyDataSource);
    settingsDataSource = SettingsLocalDataSourceImpl();
    settingsRepository = SettingsRepositoryImpl(settingsDataSource);

    await Hive.box<AnalysisHiveModel>(StorageKeys.analysisHistoryBox).clear();
    await Hive.box(SettingsConfig.settingsBox).clear();
  });

  AnalysisResult sampleResult({required String id}) {
    return AnalysisResult(
      analysisId: id,
      mediaType: 'image',
      prediction: 'authentic',
      confidence: 0.92,
      riskScore: 12,
      reasoning: 'No manipulation artifacts detected.',
      detectedArtifacts: const [],
      recommendations: const ['Proceed with standard verification.'],
      processingTime: 1200,
      timestamp: DateTime(2026, 6, 21, 12),
      modelVersion: 'gemini-3.1-pro',
      analysisSource: 'gemini',
    );
  }

  group('Hive analysis history', () {
    test('saves, loads, and clears history via repository', () async {
      final saveResult = await historyRepository.saveAnalysis(
        sampleResult(id: 'scan-1'),
      );
      expect(saveResult, isA<Success<bool>>());

      final historyResult = await historyRepository.getHistory();
      expect(historyResult, isA<Success<List<AnalysisResult>>>());

      final history = (historyResult as Success<List<AnalysisResult>>).data;
      expect(history, hasLength(1));
      expect(history.first.analysisId, 'scan-1');

      final clearResult = await historyRepository.clearHistory();
      expect(clearResult, isA<Success<bool>>());

      final emptyHistory = await historyRepository.getHistory();
      expect(
        (emptyHistory as Success<List<AnalysisResult>>).data,
        isEmpty,
      );
    });

    test('persists AnalysisHiveModel through local data source', () async {
      final model = AnalysisHiveModel(
        analysisId: 'scan-2',
        mediaPath: '/tmp/sample.jpg',
        mediaType: 'image',
        prediction: 'manipulated',
        confidence: 0.81,
        riskScore: 74,
        timestamp: DateTime(2026, 6, 21, 13),
        processingTime: 900,
        modelVersion: 'gpt-4.5-turbo',
        providerUsed: 'openai',
        serializedResult: '{"analysisId":"scan-2"}',
      );

      await historyDataSource.saveAnalysis(model);
      final loaded = await historyDataSource.getAllAnalyses();

      expect(loaded, hasLength(1));
      expect(loaded.first.analysisId, 'scan-2');
      expect(loaded.first.providerUsed, 'openai');
    });
  });

  group('Hive settings persistence', () {
    test('loads defaults when no settings exist', () async {
      final result = await settingsRepository.loadSettings();
      expect(result, isA<Success<Settings>>());

      final settings = (result as Success<Settings>).data;
      expect(settings.themeMode, SettingsConfig.themeSystem);
      expect(settings.selectedProvider, SettingsConfig.providerGemini);
      expect(settings.apiKeys, isEmpty);
    });

    test('persists theme, provider, and API keys', () async {
      final saveResult = await settingsRepository.saveSettings(
        Settings(
          themeMode: SettingsConfig.themeDark,
          selectedProvider: SettingsConfig.providerOpenAI,
          apiKeys: {
            SettingsConfig.providerOpenAI: 'sk-test-key-12345678',
          },
        ),
      );
      expect(saveResult, isA<Success<Settings>>());

      final reload = await settingsRepository.loadSettings();
      final settings = (reload as Success<Settings>).data;

      expect(settings.themeMode, SettingsConfig.themeDark);
      expect(settings.selectedProvider, SettingsConfig.providerOpenAI);
      expect(
        settings.apiKeys[SettingsConfig.providerOpenAI],
        'sk-test-key-12345678',
      );
    });

    test('updateApiKey uses in-memory snapshot without race', () async {
      await settingsRepository.saveSettings(Settings.defaults());

      final updateResult = await settingsRepository.updateApiKey(
        providerKey: SettingsConfig.providerGemini,
        apiKey: 'gemini-key-12345678',
        current: Settings(
          themeMode: SettingsConfig.themeLight,
          selectedProvider: SettingsConfig.providerGemini,
          apiKeys: const {},
        ),
      );

      expect(updateResult, isA<Success<Settings>>());
      final settings = (updateResult as Success<Settings>).data;
      expect(settings.themeMode, SettingsConfig.themeLight);
      expect(
        settings.apiKeys[SettingsConfig.providerGemini],
        'gemini-key-12345678',
      );
    });
  });
}
