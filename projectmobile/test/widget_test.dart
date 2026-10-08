// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:projectmobile/main.dart';

void main() {
  testWidgets('App loads login page and navigates to profile on login',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the login page components are present.
    expect(find.text('Nama Pengguna'), findsOneWidget);
    expect(find.text('Kata Sandi'), findsOneWidget);
    expect(find.text('MASUK'), findsOneWidget);

    // Enter hardcoded credentials
    await tester.enterText(find.byType(TextField).first, 'ASEP KOPLING');
    await tester.enterText(find.byType(TextField).last, '123456');

    // Tap the login button
    await tester.tap(find.text('MASUK'));
    await tester.pumpAndSettle();

    // Verify that it transitioned to profile page
    expect(find.text('AKUN'), findsOneWidget);
    expect(find.text('asepkopling@gmail.com'), findsOneWidget);
  });
}
