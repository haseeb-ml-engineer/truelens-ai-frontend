import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'core/config/env_config.dart';
import 'core/storage/hive_service.dart';

/// Entry point for TrueLens AI.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment configuration before anything else.
  // Defaults to .env.dev — swap to .env.prod for production builds.
  await EnvConfig.init();

  // Initialize Hive for offline history storage
  await HiveService.init();

  // Set preferred orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(
    // Wrap the app in ProviderScope for Riverpod
    const ProviderScope(child: TrueLensApp()),
  );
}