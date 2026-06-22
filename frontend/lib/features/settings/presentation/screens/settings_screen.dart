import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/settings_config.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../providers/settings_actions_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/api_key_field.dart';
import '../widgets/provider_selector.dart';
import '../widgets/settings_section.dart';
import '../widgets/theme_selector.dart';

/// Production Settings screen for TrueLens AI.
///
/// Provides theme selection, AI provider switching, API key management,
/// about information, and history clearing — all persisted via Hive.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(settingsProvider);
    final theme = Theme.of(context);

    if (settingsState.isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text(AppStrings.settingsTitle)),
        body: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: AppSpacing.spacing16),
              Text(AppStrings.settingsLoading),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.settingsTitle),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.spacing24,
            vertical: AppSpacing.spacing16,
          ),
          children: [
            if (settingsState.errorMessage != null) ...[
              _ErrorBanner(message: settingsState.errorMessage!),
              const SizedBox(height: AppSpacing.spacing16),
            ],

            // ——— Appearance ———
            SettingsSection(
              title: AppStrings.settingsAppearance,
              child: Column(
                children: [
                  ThemeSelector(
                    selectedThemeMode: settingsState.themeMode,
                    onThemeChanged: (mode) {
                      ref.read(settingsProvider.notifier).setThemeMode(mode);
                    },
                  ),
                  const SizedBox(height: AppSpacing.spacing12),
                  AppCard(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.spacing16,
                      vertical: AppSpacing.spacing8,
                    ),
                    child: SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        AppStrings.darkMode,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        AppStrings.settingsThemeMode,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      value: _isDarkModeActive(context, settingsState.themeMode),
                      onChanged: (isDark) {
                        ref
                            .read(settingsProvider.notifier)
                            .toggleDarkMode(isDark);
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.spacing32),

            // ——— AI Provider ———
            SettingsSection(
              title: AppStrings.settingsAiProvider,
              subtitle: AppStrings.settingsAiProviderSubtitle,
              child: ProviderSelector(
                selectedProviderKey: settingsState.selectedProvider,
                onProviderChanged: (key) {
                  ref.read(settingsProvider.notifier).setSelectedProvider(key);
                },
              ),
            ),

            const SizedBox(height: AppSpacing.spacing32),

            // ——— API Keys ———
            SettingsSection(
              title: AppStrings.settingsApiKeys,
              subtitle: AppStrings.settingsApiKeysSubtitle,
              child: Column(
                children: [
                  ApiKeyField(
                    providerKey: SettingsConfig.providerGemini,
                    label: AppStrings.settingsGeminiKey,
                    storedKey: settingsState.apiKeys[SettingsConfig.providerGemini] ?? '',
                    onSave: (value) => ref.read(settingsProvider.notifier).saveApiKey(
                          providerKey: SettingsConfig.providerGemini,
                          apiKey: value,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.spacing12),
                  ApiKeyField(
                    providerKey: SettingsConfig.providerOpenAI,
                    label: AppStrings.settingsOpenAiKey,
                    storedKey: settingsState.apiKeys[SettingsConfig.providerOpenAI] ?? '',
                    onSave: (value) => ref.read(settingsProvider.notifier).saveApiKey(
                          providerKey: SettingsConfig.providerOpenAI,
                          apiKey: value,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.spacing12),
                  ApiKeyField(
                    providerKey: SettingsConfig.providerClaude,
                    label: AppStrings.settingsClaudeKey,
                    storedKey: settingsState.apiKeys[SettingsConfig.providerClaude] ?? '',
                    onSave: (value) => ref.read(settingsProvider.notifier).saveApiKey(
                          providerKey: SettingsConfig.providerClaude,
                          apiKey: value,
                        ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.spacing32),

            // ——— Data ———
            SettingsSection(
              title: AppStrings.settingsClearHistory,
              subtitle: AppStrings.settingsClearHistorySubtitle,
              child: AppCard(
                padding: const EdgeInsets.all(AppSpacing.spacing16),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    Icons.delete_outline,
                    color: AppColors.error,
                  ),
                  title: Text(
                    AppStrings.settingsClearHistory,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.error,
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _confirmClearHistory(context, ref),
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.spacing32),

            // ——— About ———
            SettingsSection(
              title: AppStrings.settingsAbout,
              child: AppCard(
                padding: const EdgeInsets.all(AppSpacing.spacing16),
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        Icons.shield_outlined,
                        color: theme.colorScheme.primary,
                      ),
                      title: Text(
                        AppStrings.appName,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(AppStrings.appTagline),
                    ),
                    const Divider(),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.info_outline),
                      title: Text(AppStrings.settingsVersion),
                      trailing: Text(
                        AppStrings.appVersion,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.spacing48),
          ],
        ),
      ),
    );
  }

  bool _isDarkModeActive(BuildContext context, String themeMode) {
    switch (themeMode) {
      case SettingsConfig.themeDark:
        return true;
      case SettingsConfig.themeLight:
        return false;
      case SettingsConfig.themeSystem:
      default:
        return MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    }
  }

  Future<void> _confirmClearHistory(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.settingsClearHistoryConfirmTitle),
        content: const Text(AppStrings.settingsClearHistoryConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(AppStrings.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text(AppStrings.confirm),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    final clearHistory = ref.read(clearAnalysisHistoryProvider);
    final result = await clearHistory();

    if (!context.mounted) return;

    result.fold(
      (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppStrings.settingsClearHistorySuccess)),
        );
      },
      (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppStrings.settingsClearHistoryFailed)),
        );
      },
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;

  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.spacing12),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: theme.colorScheme.error),
          const SizedBox(width: AppSpacing.spacing8),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onErrorContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
