import 'package:book_ease/features/settings/presentation/views/settings_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SettingsView Widget Tests', () {
    testWidgets('renders all preference options, version badge, and switches',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SettingsView(),
        ),
      );

      // Verify title
      expect(find.text('Settings & Privacy'), findsOneWidget);

      // Verify section titles
      expect(find.text('PREFERENCES'), findsOneWidget);
      expect(find.text('ACCOUNT & SECURITY'), findsOneWidget);
      expect(find.text('LEGAL & SUPPORT'), findsOneWidget);

      // Verify preference items
      expect(find.text('Push Notifications'), findsOneWidget);
      expect(find.text('Face ID / Biometrics'), findsOneWidget);
      expect(find.text('Sound & Vibrations'), findsOneWidget);
      expect(find.text('Email Appointment Updates'), findsOneWidget);
      expect(find.text('Language'), findsOneWidget);

      // Verify version and legal items
      expect(find.text('2.6.0 Production'), findsOneWidget);
      expect(find.text('Terms of Service'), findsOneWidget);
      expect(find.text('Privacy Policy'), findsOneWidget);

      // Verify buttons (Log Out removed from Settings, only present in Profile)
      expect(find.text('Log Out'), findsNothing);
      expect(find.text('Save Settings'), findsOneWidget);

      // Verify switches exist and can be toggled
      final switches = find.byType(CupertinoSwitch);
      expect(switches, findsNWidgets(4));

      // Toggle first switch (Push Notifications)
      await tester.tap(switches.first);
      await tester.pumpAndSettle();

      // Tap Save Settings button
      await tester.tap(find.text('Save Settings'));
      await tester.pump();
      expect(find.text('Settings saved successfully'), findsOneWidget);
    });
  });
}
