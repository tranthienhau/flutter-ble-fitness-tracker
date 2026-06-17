import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:firepaw_fitness/main.dart';

void main() {
  testWidgets('Connect screen renders scan button', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: FirepawApp()));
    expect(find.text('SCAN FOR SENSORS'), findsOneWidget);
    expect(find.text('CONNECT SENSOR'), findsOneWidget);
  });
}
