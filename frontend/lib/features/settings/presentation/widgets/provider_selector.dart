import 'package:flutter/material.dart';

import '../../../../core/config/provider_config.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';

/// Dropdown for selecting the active AI analysis provider.
class ProviderSelector extends StatelessWidget {
  final String selectedProviderKey;
  final ValueChanged<String> onProviderChanged;

  const ProviderSelector({
    super.key,
    required this.selectedProviderKey,
    required this.onProviderChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.spacing16,
        vertical: AppSpacing.spacing4,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedProviderKey,
          isExpanded: true,
          icon: Icon(Icons.expand_more, color: theme.colorScheme.onSurfaceVariant),
          items: ProviderType.values
              .map(
                (provider) => DropdownMenuItem<String>(
                  value: provider.key,
                  child: Row(
                    children: [
                      Icon(
                        _iconForProvider(provider),
                        size: AppSpacing.iconMedium,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: AppSpacing.spacing12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              provider.displayName,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              provider.defaultModel,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value != null) onProviderChanged(value);
          },
        ),
      ),
    );
  }

  IconData _iconForProvider(ProviderType provider) {
    return switch (provider) {
      ProviderType.gemini => Icons.auto_awesome,
      ProviderType.openAI => Icons.psychology_outlined,
      ProviderType.claude => Icons.smart_toy_outlined,
      ProviderType.trueLens => Icons.shield_outlined,
    };
  }
}
