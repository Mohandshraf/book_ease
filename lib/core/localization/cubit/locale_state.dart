import 'package:flutter/widgets.dart';

class LocaleState {
  final Locale locale;
  final String languageCode;
  final bool isRtl;

  const LocaleState({
    required this.locale,
    required this.languageCode,
    required this.isRtl,
  });

  factory LocaleState.fromLanguageCode(String languageCode) {
    return LocaleState(
      locale: Locale(languageCode),
      languageCode: languageCode,
      isRtl: languageCode == 'ar',
    );
  }
}
