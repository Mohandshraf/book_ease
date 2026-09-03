import 'package:bloc_test/bloc_test.dart';
import 'package:book_ease/core/localization/cubit/locale_cubit.dart';
import 'package:book_ease/core/localization/cubit/locale_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LocaleCubit', () {
    late LocaleCubit localeCubit;

    setUp(() {
      localeCubit = LocaleCubit();
    });

    tearDown(() {
      localeCubit.close();
    });

    test('initial state is English and LTR', () {
      expect(localeCubit.state.languageCode, 'en');
      expect(localeCubit.state.locale.languageCode, 'en');
      expect(localeCubit.state.isRtl, false);
    });

    blocTest<LocaleCubit, LocaleState>(
      'emits Arabic state with isRtl=true when languageCode is "ar"',
      build: () => LocaleCubit(),
      act: (cubit) => cubit.changeLanguage('ar'),
      expect: () => [
        isA<LocaleState>()
            .having((s) => s.languageCode, 'languageCode', 'ar')
            .having((s) => s.isRtl, 'isRtl', true),
      ],
    );

    blocTest<LocaleCubit, LocaleState>(
      'normalizes "العربية" to "ar"',
      build: () => LocaleCubit(),
      act: (cubit) => cubit.changeLanguage('العربية'),
      expect: () => [
        isA<LocaleState>()
            .having((s) => s.languageCode, 'languageCode', 'ar')
            .having((s) => s.isRtl, 'isRtl', true),
      ],
    );

    blocTest<LocaleCubit, LocaleState>(
      'emits French state with isRtl=false when languageCode is "fr"',
      build: () => LocaleCubit(),
      act: (cubit) => cubit.changeLanguage('fr'),
      expect: () => [
        isA<LocaleState>()
            .having((s) => s.languageCode, 'languageCode', 'fr')
            .having((s) => s.isRtl, 'isRtl', false),
      ],
    );

    blocTest<LocaleCubit, LocaleState>(
      'emits Spanish state with isRtl=false when languageCode is "es"',
      build: () => LocaleCubit(),
      act: (cubit) => cubit.changeLanguage('es'),
      expect: () => [
        isA<LocaleState>()
            .having((s) => s.languageCode, 'languageCode', 'es')
            .having((s) => s.isRtl, 'isRtl', false),
      ],
    );

    blocTest<LocaleCubit, LocaleState>(
      'does not emit when changing to the current active language',
      build: () => LocaleCubit('en'),
      act: (cubit) => cubit.changeLanguage('en'),
      expect: () => [],
    );
  });
}
