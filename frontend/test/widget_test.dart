import 'package:deepshield_ai/app.dart';
import 'package:deepshield_ai/core/config/env_config.dart';
import 'package:deepshield_ai/core/storage/hive_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await EnvConfig.init();
    await HiveService.init();
  });

  testWidgets('TrueLens app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: TrueLensApp()),
    );

    expect(find.byType(TrueLensApp), findsOneWidget);

    // Allow splash/onboarding timers to complete so the test exits cleanly.
    await tester.pumpAndSettle(const Duration(seconds: 10));
  });
}
