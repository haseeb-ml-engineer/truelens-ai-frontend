import 'dart:io';

void main() {
  final dir = Directory('lib');
  final files = dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));

  final replacements = {
    "context.go('/dashboard')": "context.go(RoutePaths.dashboard)",
    "context.go('/history')": "context.go(RoutePaths.history)",
    "context.go('/login')": "context.go(RoutePaths.login)",
    "context.go('/onboarding')": "context.go(RoutePaths.onboarding)",
    "context.go('/profile')": "context.go(RoutePaths.profile)",
    "context.push('/forgot-password')": "context.push(RoutePaths.forgotPassword)",
    "context.push('/notifications')": "context.push(RoutePaths.notifications)",
    "context.push('/processing')": "context.push(RoutePaths.processing)",
    "context.push('/signup')": "context.push(RoutePaths.signUp)",
    "context.push('/upload')": "context.push(RoutePaths.upload)",
    "context.go('/results/scan_001')": "context.goNamed(RouteNames.results, pathParameters: {'scanId': 'scan_001'})",
    "context.push('/results/scan_001')": "context.pushNamed(RouteNames.results, pathParameters: {'scanId': 'scan_001'})",
    "context.push('/results/\${scan.id}')": "context.pushNamed(RouteNames.results, pathParameters: {'scanId': scan.id})",
    "context.push('/report/\${_scan.id}')": "context.pushNamed(RouteNames.reportDetails, pathParameters: {'scanId': _scan.id})",
  };

  for (final file in files) {
    if (file.path.contains('app_router.dart')) continue;

    String content = file.readAsStringSync();
    bool changed = false;

    replacements.forEach((oldStr, newStr) {
      if (content.contains(oldStr)) {
        content = content.replaceAll(oldStr, newStr);
        changed = true;
      }
    });

    if (changed) {
      if (!content.contains('package:deepshield_ai/routes/app_router.dart')) {
        content = "import 'package:deepshield_ai/routes/app_router.dart';\n" + content;
      }
      file.writeAsStringSync(content);
      print('Updated routing in \${file.path}');
    }
  }
}
