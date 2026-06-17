import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:integration_test/integration_test.dart';

import 'package:firepaw_fitness/main.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // The connect screen has an always-on pulse animation, so we use fixed
  // pump() durations everywhere instead of pumpAndSettle (which never settles).
  Future<void> shot(WidgetTester tester, String name) async {
    await binding.convertFlutterSurfaceToImage();
    await tester.pump(const Duration(milliseconds: 400));
    await binding.takeScreenshot(name);
  }

  testWidgets('capture key screens', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: FirepawApp()));
    await tester.pump(const Duration(milliseconds: 600));

    // 01 - Connect screen (idle)
    await shot(tester, '01-connect');

    // Scan for sensors -> discovered devices
    await tester.tap(find.text('SCAN FOR SENSORS'));
    await tester.pump(const Duration(milliseconds: 300)); // scanning state
    await tester.pump(const Duration(milliseconds: 1600)); // results arrive
    await shot(tester, '02-devices-found');

    // Connect first sensor -> jumps to Live screen
    await tester.tap(find.text('CONNECT').first);
    await tester.pump(const Duration(milliseconds: 1200));
    await shot(tester, '03-live-idle');

    // Start session -> live metrics streaming. Let it run long enough that the
    // warm-up -> steady-run speed curve and distance are well populated.
    await tester.tap(find.text('START SESSION'));
    await tester.pump(const Duration(seconds: 8));
    await shot(tester, '04-live-running');
    await tester.pump(const Duration(seconds: 6));

    // Finish workout -> summary screen
    await tester.tap(find.text('FINISH WORKOUT'));
    await tester.pump(const Duration(milliseconds: 800));
    await shot(tester, '05-summary');

    // Back to home, then open History tab
    await tester.tap(find.text('DONE'));
    await tester.pump(const Duration(milliseconds: 600));
    await tester.tap(find.text('HISTORY'));
    await tester.pump(const Duration(milliseconds: 600));
    await shot(tester, '06-history');
  });
}
