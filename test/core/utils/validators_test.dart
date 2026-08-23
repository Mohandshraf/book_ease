import 'package:book_ease/core/utils/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Validators Test Suite', () {
    group('Name Validator', () {
      test('should return error when name is empty or null', () {
        expect(Validators.name(null), 'Please enter your full name');
        expect(Validators.name('   '), 'Please enter your full name');
      });

      test('should return error when name is less than 3 characters', () {
        expect(Validators.name('Al'), 'Name must be at least 3 characters');
      });

      test('should return null when name is valid', () {
        expect(Validators.name('Alex Johnson'), isNull);
      });
    });

    group('Email Validator', () {
      test('should return error when email is null or empty', () {
        expect(Validators.email(null), 'Please enter your email');
        expect(Validators.email(''), 'Please enter your email');
      });

      test('should return error on invalid email format', () {
        expect(Validators.email('invalid-email'), 'Please enter a valid email');
        expect(Validators.email('test@domain'), 'Please enter a valid email');
        expect(Validators.email('@domain.com'), 'Please enter a valid email');
      });

      test('should return null on valid email format', () {
        expect(Validators.email('test@example.com'), isNull);
        expect(Validators.email('user.name@sub.domain.org'), isNull);
      });
    });

    group('Password Validator', () {
      test('should return error when password is null or empty', () {
        expect(Validators.password(null), 'Please enter your password');
        expect(Validators.password(''), 'Please enter your password');
      });

      test('should return error when password length < 8', () {
        expect(
          Validators.password('Pass1'),
          'Password must be at least 8 characters',
        );
      });

      test('should return error when missing uppercase letter', () {
        expect(
          Validators.password('password123'),
          'Password must contain an uppercase letter',
        );
      });

      test('should return error when missing lowercase letter', () {
        expect(
          Validators.password('PASSWORD123'),
          'Password must contain a lowercase letter',
        );
      });

      test('should return error when missing number', () {
        expect(
          Validators.password('PasswordNoNumber'),
          'Password must contain a number',
        );
      });

      test('should return null when password meets all criteria', () {
        expect(Validators.password('Password123'), isNull);
      });
    });

    group('Confirm Password Validator', () {
      test('should return error when empty', () {
        expect(
          Validators.confirmPassword(null, 'Password123'),
          'Please confirm your password',
        );
      });

      test('should return error when passwords do not match', () {
        expect(
          Validators.confirmPassword('Different123', 'Password123'),
          'Passwords do not match',
        );
      });

      test('should return null when passwords match', () {
        expect(
          Validators.confirmPassword('Password123', 'Password123'),
          isNull,
        );
      });
    });

    group('Phone Validator', () {
      test('should return error when phone is empty or null', () {
        expect(Validators.phone(null), 'Please enter your phone number');
      });

      test('should return error when phone does not have 11 digits', () {
        expect(Validators.phone('12345'), 'Please enter a valid phone number');
        expect(Validators.phone('abcdefghijk'), 'Please enter a valid phone number');
      });

      test('should return null when phone has valid 11 digits', () {
        expect(Validators.phone('01234567890'), isNull);
      });
    });
  });
}
