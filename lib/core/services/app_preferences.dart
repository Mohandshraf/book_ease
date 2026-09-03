import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  final SharedPreferences _prefs;

  AppPreferences(this._prefs);

  static const String _keyOnboardingSeen = 'is_onboarding_seen';
  static const String _keyUserRole = 'user_role';

  /// Whether the user has completed or skipped the onboarding flow.
  bool get isOnboardingSeen => _prefs.getBool(_keyOnboardingSeen) ?? false;

  /// Sets the onboarding seen status.
  Future<bool> setOnboardingSeen(bool seen) async {
    return await _prefs.setBool(_keyOnboardingSeen, seen);
  }

  /// The cached user role ('customer' or 'provider').
  String? get userRole => _prefs.getString(_keyUserRole);

  /// Caches the user role for instant splash screen routing.
  Future<bool> setUserRole(String role) async {
    return await _prefs.setString(_keyUserRole, role);
  }

  /// Clears the cached user role on sign out.
  Future<bool> clearUserRole() async {
    return await _prefs.remove(_keyUserRole);
  }

  /// Resets all stored preferences.
  Future<bool> clearAll() async {
    return await _prefs.clear();
  }
}
