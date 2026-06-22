import 'dart:io';

void main() {
  final dir = Directory('lib');
  final files = dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));

  final map = {
    // Models
    'notification_model.dart': 'features/notifications/data/models/notification_model.dart',
    'report_model.dart': 'features/reports/data/models/report_model.dart',
    'scan_result_model.dart': 'features/analysis/data/models/scan_result_model.dart',
    'user_model.dart': 'features/authentication/data/models/user_model.dart',

    // Services
    'analysis_service.dart': 'features/analysis/data/datasources/analysis_service.dart',
    'auth_service.dart': 'features/authentication/data/datasources/auth_service.dart',
    'history_service.dart': 'features/history/data/datasources/history_service.dart',
    'profile_service.dart': 'features/profile/data/datasources/profile_service.dart',
    'report_service.dart': 'features/reports/data/datasources/report_service.dart',

    // Providers
    'analysis_provider.dart': 'features/analysis/presentation/providers/analysis_provider.dart',
    'auth_provider.dart': 'features/authentication/presentation/providers/auth_provider.dart',
    'history_provider.dart': 'features/history/presentation/providers/history_provider.dart',
    'navigation_provider.dart': 'features/dashboard/presentation/providers/navigation_provider.dart',
    'notification_provider.dart': 'features/notifications/presentation/providers/notification_provider.dart',

    // Screens
    'processing_screen.dart': 'features/analysis/presentation/screens/processing_screen.dart',
    'results_screen.dart': 'features/analysis/presentation/screens/results_screen.dart',
    'forgot_password_screen.dart': 'features/authentication/presentation/screens/forgot_password_screen.dart',
    'login_screen.dart': 'features/authentication/presentation/screens/login_screen.dart',
    'signup_screen.dart': 'features/authentication/presentation/screens/signup_screen.dart',
    'dashboard_screen.dart': 'features/dashboard/presentation/screens/dashboard_screen.dart',
    'history_screen.dart': 'features/history/presentation/screens/history_screen.dart',
    'notifications_screen.dart': 'features/notifications/presentation/screens/notifications_screen.dart',
    'onboarding_screen.dart': 'features/onboarding/presentation/screens/onboarding_screen.dart',
    'profile_screen.dart': 'features/profile/presentation/screens/profile_screen.dart',
    'report_details_screen.dart': 'features/reports/presentation/screens/report_details_screen.dart',
    'splash_screen.dart': 'features/splash/presentation/screens/splash_screen.dart',
    'upload_screen.dart': 'features/upload/presentation/screens/upload_screen.dart',
  };

  for (final file in files) {
    String content = file.readAsStringSync();
    bool changed = false;

    // Use a simple heuristic: replace any import that ends with the old filename
    // to use package:deepshield_ai/new_path
    map.forEach((fileName, newPath) {
      // Find relative imports or package imports ending in fileName
      final regex = RegExp(r"import\s+['""]([^'""]*)" + RegExp.escape(fileName) + r"['""]\s*;");
      if (regex.hasMatch(content)) {
        content = content.replaceAll(regex, "import 'package:deepshield_ai/$newPath';");
        changed = true;
      }
    });

    if (changed) {
      file.writeAsStringSync(content);
      print('Updated imports in ${file.path}');
    }
  }
}
