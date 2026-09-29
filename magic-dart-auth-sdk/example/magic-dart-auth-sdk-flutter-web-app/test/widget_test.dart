import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:magic_dart_auth_sdk_flutter_web_app/main.dart';

void main() {
  testWidgets('Example opens its token validation screen', (tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Magic Dart Auth Web Sample'), findsOneWidget);
    await tester.ensureVisible(find.text('MagicTokenValidator'));
    await tester.tap(find.text('MagicTokenValidator'));
    await tester.pumpAndSettle();
    expect(find.byType(TextField), findsWidgets);
    expect(tester.takeException(), isNull);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Magic Dart Auth Web Sample'), findsOneWidget);
  });
}
