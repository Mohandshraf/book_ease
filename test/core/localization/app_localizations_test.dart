import 'package:book_ease/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppLocalizations & Delegate Tests', () {
    test('supports en, ar, fr, es locales', () {
      const delegate = AppLocalizations.delegate;
      expect(delegate.isSupported(const Locale('en')), isTrue);
      expect(delegate.isSupported(const Locale('ar')), isTrue);
      expect(delegate.isSupported(const Locale('fr')), isTrue);
      expect(delegate.isSupported(const Locale('es')), isTrue);
      expect(delegate.isSupported(const Locale('de')), isFalse);
    });

    test('translates English correctly', () {
      final loc = AppLocalizations(const Locale('en'));
      expect(loc.translate('common_save'), 'Save');
      expect(loc.translate('nav_home'), 'Home');
      expect(loc.translate('settings_title'), 'Settings & Privacy');
      expect(loc.isRtl, isFalse);
    });

    test('translates Arabic correctly and marks as RTL', () {
      final loc = AppLocalizations(const Locale('ar'));
      expect(loc.translate('common_save'), 'حفظ');
      expect(loc.translate('nav_home'), 'الرئيسية');
      expect(loc.translate('settings_title'), 'الإعدادات والخصوصية');
      expect(loc.isRtl, isTrue);
    });

    test('translates French correctly', () {
      final loc = AppLocalizations(const Locale('fr'));
      expect(loc.translate('common_save'), 'Enregistrer');
      expect(loc.translate('nav_home'), 'Accueil');
      expect(loc.isRtl, isFalse);
    });

    test('translates Spanish correctly', () {
      final loc = AppLocalizations(const Locale('es'));
      expect(loc.translate('common_save'), 'Guardar');
      expect(loc.translate('nav_home'), 'Inicio');
      expect(loc.isRtl, isFalse);
    });

    test('falls back to English or key when key is unknown', () {
      final loc = AppLocalizations(const Locale('ar'));
      expect(loc.translate('unknown_dummy_key_123'), 'unknown_dummy_key_123');
    });

    testWidgets('context.tr works inside widget tree with Arabic locale',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ar'),
          supportedLocales: const [
            Locale('en'),
            Locale('ar'),
          ],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: Column(
                  children: [
                    Text(context.tr('nav_bookings')),
                    Text(context.tr('profile_title')),
                    Text(Directionality.of(context) == TextDirection.rtl
                        ? 'IS_RTL'
                        : 'IS_LTR'),
                  ],
                ),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('حجوزاتي'), findsOneWidget);
      expect(find.text('الملف الشخصي'), findsOneWidget);
      expect(find.text('IS_RTL'), findsOneWidget);
    });
  });
}
