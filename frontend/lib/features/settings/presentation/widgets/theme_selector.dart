import 'package:flutter/material.dart';

import '../../../../core/config/settings_config.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';

/// Segmented theme selector supporting Light, Dark, and System modes.
class ThemeSelector extends StatelessWidget {
  final String selectedThemeMode;
  final ValueChanged<String> onThemeChanged;

  const ThemeSelector({
    super.key,
    required this.selectedThemeMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.spacing4),
      child: SegmentedButton<String>(
        segments: const [
          ButtonSegment(
            value: SettingsConfig.themeLight,
            label: Text(AppStrings.settingsThemeLight),
            icon: Icon(Icons.light_mode_outlined, size: 18),
          ),
          ButtonSegment(
            value: SettingsConfig.themeDark,
            label: Text(AppStrings.settingsThemeDark),
            icon: Icon(Icons.dark_mode_outlined, size: 18),
          ),
          ButtonSegment(
            value: SettingsConfig.themeSystem,
            label: Text(AppStrings.settingsThemeSystem),
            icon: Icon(Icons.settings_brightness_outlined, size: 18),
          ),
        ],
        selected: {selectedThemeMode},
        onSelectionChanged: (selection) {
          if (selection.isNotEmpty) {
            onThemeChanged(selection.first);
          }
        },
        style: ButtonStyle(
          visualDensity: VisualDensity.compact,
          textStyle: WidgetStatePropertyAll(
            theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
