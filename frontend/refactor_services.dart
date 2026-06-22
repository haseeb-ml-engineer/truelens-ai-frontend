import 'dart:io';

void main() {
  final dir = Directory('lib');
  final files = dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));

  final map = {
    'AuthService': 'MockAuthRepository',
    'AnalysisService': 'MockAnalysisRepository',
    'HistoryService': 'MockHistoryRepository',
    'ProfileService': 'MockProfileRepository',
    'ReportService': 'MockReportRepository',
    'data/datasources/auth_service.dart': 'data/repositories/mock_auth_repository.dart',
    'data/datasources/analysis_service.dart': 'data/repositories/mock_analysis_repository.dart',
    'data/datasources/history_service.dart': 'data/repositories/mock_history_repository.dart',
    'data/datasources/profile_service.dart': 'data/repositories/mock_profile_repository.dart',
    'data/datasources/report_service.dart': 'data/repositories/mock_report_repository.dart',
  };

  for (final file in files) {
    String content = file.readAsStringSync();
    bool changed = false;

    map.forEach((oldStr, newStr) {
      if (content.contains(oldStr)) {
        content = content.replaceAll(oldStr, newStr);
        changed = true;
      }
    });
    
    // Also inject `implements Interface` into the mock classes themselves
    if (file.path.contains('mock_auth_repository.dart') && content.contains('class MockAuthRepository {')) {
      content = "import 'package:deepshield_ai/features/authentication/domain/repositories/auth_repository.dart';\n" + 
                content.replaceAll('class MockAuthRepository {', 'class MockAuthRepository implements AuthRepository {');
      changed = true;
    }
    if (file.path.contains('mock_analysis_repository.dart') && content.contains('class MockAnalysisRepository {')) {
      content = "import 'package:deepshield_ai/features/analysis/domain/repositories/analysis_repository.dart';\n" + 
                content.replaceAll('class MockAnalysisRepository {', 'class MockAnalysisRepository implements AnalysisRepository {');
      changed = true;
    }
    if (file.path.contains('mock_history_repository.dart') && content.contains('class MockHistoryRepository {')) {
      content = "import 'package:deepshield_ai/features/history/domain/repositories/history_repository.dart';\n" + 
                content.replaceAll('class MockHistoryRepository {', 'class MockHistoryRepository implements HistoryRepository {');
      changed = true;
    }
    if (file.path.contains('mock_profile_repository.dart') && content.contains('class MockProfileRepository {')) {
      content = "import 'package:deepshield_ai/features/profile/domain/repositories/profile_repository.dart';\n" + 
                content.replaceAll('class MockProfileRepository {', 'class MockProfileRepository implements ProfileRepository {');
      changed = true;
    }
    if (file.path.contains('mock_report_repository.dart') && content.contains('class MockReportRepository {')) {
      content = "import 'package:deepshield_ai/features/reports/domain/repositories/report_repository.dart';\n" + 
                content.replaceAll('class MockReportRepository {', 'class MockReportRepository implements ReportRepository {');
      changed = true;
    }
    
    // In providers, change the provider type to the interface.
    // e.g. final authServiceProvider = Provider<MockAuthRepository>((ref) => MockAuthRepository());
    // -> final authServiceProvider = Provider<AuthRepository>((ref) => MockAuthRepository());
    if (file.path.endsWith('_provider.dart')) {
      content = content.replaceAll('Provider<MockAuthRepository>', 'Provider<AuthRepository>');
      content = content.replaceAll('Provider<MockAnalysisRepository>', 'Provider<AnalysisRepository>');
      content = content.replaceAll('Provider<MockHistoryRepository>', 'Provider<HistoryRepository>');
      content = content.replaceAll('Provider<MockProfileRepository>', 'Provider<ProfileRepository>');
      content = content.replaceAll('Provider<MockReportRepository>', 'Provider<ReportRepository>');
      
      // Inject interface imports into providers
      if (content.contains('Provider<AuthRepository>') && !content.contains('auth_repository.dart')) {
        content = "import 'package:deepshield_ai/features/authentication/domain/repositories/auth_repository.dart';\n" + content;
      }
      if (content.contains('Provider<AnalysisRepository>') && !content.contains('analysis_repository.dart')) {
        content = "import 'package:deepshield_ai/features/analysis/domain/repositories/analysis_repository.dart';\n" + content;
      }
      if (content.contains('Provider<HistoryRepository>') && !content.contains('history_repository.dart')) {
        content = "import 'package:deepshield_ai/features/history/domain/repositories/history_repository.dart';\n" + content;
      }
      if (content.contains('Provider<ProfileRepository>') && !content.contains('profile_repository.dart')) {
        content = "import 'package:deepshield_ai/features/profile/domain/repositories/profile_repository.dart';\n" + content;
      }
      if (content.contains('Provider<ReportRepository>') && !content.contains('report_repository.dart')) {
        content = "import 'package:deepshield_ai/features/reports/domain/repositories/report_repository.dart';\n" + content;
      }
    }

    if (changed) {
      file.writeAsStringSync(content);
      print('Refactored \${file.path}');
    }
  }
}
