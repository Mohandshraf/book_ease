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

  String get languageCode {
    return AppLocalizations.of(this)?.locale.languageCode ?? 'en';
  }

  String localizedMonthShort(int month) {
    const en = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    const ar = ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'];
    const fr = ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Juin', 'Juil', 'Aoû', 'Sep', 'Oct', 'Nov', 'Déc'];
    const es = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];

    final idx = (month - 1).clamp(0, 11);
    switch (languageCode) {
      case 'ar':
        return ar[idx];
      case 'fr':
        return fr[idx];
      case 'es':
        return es[idx];
      default:
        return en[idx];
    }
  }

  String localizedMonthFull(int month) {
    const en = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    const ar = [
      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
    ];
    const fr = [
      'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
      'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'
    ];
    const es = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];

    final idx = (month - 1).clamp(0, 11);
    switch (languageCode) {
      case 'ar':
        return ar[idx];
      case 'fr':
        return fr[idx];
      case 'es':
        return es[idx];
      default:
        return en[idx];
    }
  }

  String localizedWeekdayShort(int weekday) {
    const en = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const ar = ['إثنين', 'ثلاثاء', 'أربعاء', 'خميس', 'جمعة', 'سبت', 'أحد'];
    const fr = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
    const es = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];

    final idx = (weekday - 1).clamp(0, 6);
    switch (languageCode) {
      case 'ar':
        return ar[idx];
      case 'fr':
        return fr[idx];
      case 'es':
        return es[idx];
      default:
        return en[idx];
    }
  }

  String localizedWeekdayFull(int weekday) {
    const en = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    const ar = ['الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت', 'الأحد'];
    const fr = ['Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi', 'Dimanche'];
    const es = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];

    final idx = (weekday - 1).clamp(0, 6);
    switch (languageCode) {
      case 'ar':
        return ar[idx];
      case 'fr':
        return fr[idx];
      case 'es':
        return es[idx];
      default:
        return en[idx];
    }
  }

  String localizedFormattedDate(DateTime date) {
    final dayName = localizedWeekdayFull(date.weekday);
    final monthName = localizedMonthFull(date.month);
    if (languageCode == 'ar') {
      return '$dayName، ${date.day} $monthName ${date.year}';
    }
    return '$dayName, $monthName ${date.day}, ${date.year}';
  }

  String localizedTime(String rawTime) {
    if (rawTime.isEmpty) return rawTime;
    if (languageCode == 'ar') {
      return rawTime
          .replaceAll('AM', 'ص')
          .replaceAll('am', 'ص')
          .replaceAll('PM', 'م')
          .replaceAll('pm', 'م');
    }
    return rawTime;
  }

  String localizedBookingStatus(String status) {
    final s = status.trim().toLowerCase();
    switch (s) {
      case 'pending':
        return tr('bookings_status_pending');
      case 'confirmed':
        return tr('bookings_status_confirmed');
      case 'completed':
        return tr('bookings_status_completed');
      case 'cancelled':
      case 'canceled':
        return tr('bookings_status_cancelled');
      case 'rejected':
      case 'declined':
        return tr('bookings_status_rejected');
      default:
        return status.isNotEmpty
            ? status[0].toUpperCase() + status.substring(1)
            : status;
    }
  }
}

