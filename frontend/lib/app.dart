import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/constants/app_strings.dart';
import 'core/theme/app_theme.dart';
import 'features/settings/presentation/providers/settings_provider.dart';
import 'routes/app_router.dart';

/// Root widget for the TrueLens AI application.
///
/// Configures theming, routing, and top-level providers.
class TrueLensApp extends ConsumerWidget {
  const TrueLensApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch settings for live theme switching (persisted via Hive)
    final themeMode = ref.watch(settingsThemeModeProvider);

    return MaterialApp.router(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,

      // Theme configuration
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,

      // GoRouter configuration
      routerConfig: appRouter,
    );
  }
}