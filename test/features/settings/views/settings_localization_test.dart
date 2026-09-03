import 'package:book_ease/core/localization/app_localizations.dart';
import 'package:book_ease/core/localization/cubit/locale_cubit.dart';
import 'package:book_ease/core/localization/cubit/locale_state.dart';
import 'package:book_ease/features/settings/presentation/views/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Settings Localization & Dynamic Language Switching', () {
    late LocaleCubit localeCubit;

    setUp(() {
      localeCubit = LocaleCubit();
    });

    tearDown(() {
      localeCubit.close();
    });

    testWidgets('switching language to Arabic in settings updates LocaleCubit and UI',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        BlocProvider<LocaleCubit>.value(
          value: localeCubit,
          child: BlocBuilder<LocaleCubit, LocaleState>(
            builder: (context, state) {
              return MaterialApp(
                locale: state.locale,
                supportedLocales: const [
                  Locale('en'),
                  Locale('ar'),
                  Locale('fr'),
                  Locale('es'),
                ],
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                home: const SettingsView(),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Starts in English
      expect(find.text('Settings & Privacy'), findsOneWidget);
      expect(find.text('Language'), findsOneWidget);
      expect(find.text('English (US)'), findsOneWidget);

      // Tap on the Language row to open the modal bottom sheet
      await tester.tap(find.text('Language'));
      await tester.pumpAndSettle();

      // Verify modal sheet is open with language choices
      expect(find.text('Select Language'), findsOneWidget);
      expect(find.text('العربية (Arabic)'), findsOneWidget);

      // Select Arabic
      await tester.tap(find.text('العربية (Arabic)'));
      await tester.pumpAndSettle();

      // Verify cubit state changed
      expect(localeCubit.state.languageCode, 'ar');
      expect(localeCubit.state.isRtl, isTrue);

      // Verify UI reflects Arabic translations
      expect(find.text('الإعدادات والخصوصية'), findsOneWidget);
      expect(find.text('اللغة'), findsOneWidget);
      expect(find.text('حفظ الإعدادات'), findsOneWidget);
    });
  });
}
