import 'package:book_ease/core/services/app_preferences.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppPreferences Tests', () {
    late AppPreferences appPreferences;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      appPreferences = AppPreferences(prefs);
    });

    test('isOnboardingSeen defaults to false', () {
      expect(appPreferences.isOnboardingSeen, isFalse);
    });

    test('setOnboardingSeen updates state correctly', () async {
      final result = await appPreferences.setOnboardingSeen(true);
      expect(result, isTrue);
      expect(appPreferences.isOnboardingSeen, isTrue);
    });

    test('userRole defaults to null', () {
      expect(appPreferences.userRole, isNull);
    });

    test('setUserRole and clearUserRole work correctly', () async {
      await appPreferences.setUserRole('customer');
      expect(appPreferences.userRole, equals('customer'));

      await appPreferences.clearUserRole();
      expect(appPreferences.userRole, isNull);
    });

    test('clearAll clears everything', () async {
      await appPreferences.setOnboardingSeen(true);
      await appPreferences.setUserRole('provider');

      await appPreferences.clearAll();
      expect(appPreferences.isOnboardingSeen, isFalse);
      expect(appPreferences.userRole, isNull);
    });
  });
}
