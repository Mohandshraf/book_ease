import 'package:flutter_bloc/flutter_bloc.dart';
import 'locale_state.dart';

class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit([String initialCode = 'en'])
      : super(LocaleState.fromLanguageCode(initialCode));

  void changeLanguage(String languageCode) {
    final code = _normalizeCode(languageCode);
    if (state.languageCode != code) {
      emit(LocaleState.fromLanguageCode(code));
    }
  }

  String _normalizeCode(String code) {
    final lower = code.toLowerCase();
    if (lower.startsWith('ar') || lower == 'arabic' || lower == 'العربية') {
      return 'ar';
    }
    if (lower.startsWith('fr') || lower == 'french' || lower == 'français') {
      return 'fr';
    }
    if (lower.startsWith('es') || lower == 'spanish' || lower == 'español') {
      return 'es';
    }
    return 'en';
  }
}
