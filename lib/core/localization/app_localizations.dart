import 'package:flutter/widgets.dart';
import 'translations/ar.dart';
import 'translations/en.dart';
import 'translations/es.dart';
import 'translations/fr.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': enTranslations,
    'ar': arTranslations,
    'fr': frTranslations,
    'es': esTranslations,
  };

  String translate(String key) {
    final languageCode = locale.languageCode;
    final map = _localizedValues[languageCode] ?? _localizedValues['en']!;
    return map[key] ?? _localizedValues['en']?[key] ?? key;
  }

  bool get isRtl => locale.languageCode == 'ar';
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar', 'fr', 'es'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

extension LocalizationContext on BuildContext {
  String tr(String key) {
    final localizations = AppLocalizations.of(this);
    if (localizations != null) {
      return localizations.translate(key);
    }
    return enTranslations[key] ?? key;
  }

  bool get isRtl {
    return AppLocalizations.of(this)?.isRtl ?? false;
  }
}
