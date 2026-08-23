import 'package:bloc_test/bloc_test.dart';
import 'package:book_ease/core/errors/exceptions/custom_exception.dart';
import 'package:book_ease/features/auth/data/cubit/auth_cubit.dart';
import 'package:book_ease/features/auth/data/cubit/auth_state.dart';
import 'package:book_ease/features/auth/data/repo/auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepo extends Mock implements AuthRepo {}
class MockUserCredential extends Mock implements UserCredential {}

void main() {
  late MockAuthRepo mockAuthRepo;
  late AuthCubit authCubit;

  setUp(() {
    mockAuthRepo = MockAuthRepo();
    authCubit = AuthCubit(mockAuthRepo);
  });

  tearDown(() {
    authCubit.close();
  });

  group('AuthCubit Test Suite', () {
    test('initial state is AuthInitial', () {
      expect(authCubit.state, isA<AuthInitial>());
    });

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthSuccess] when register is successful',
      build: () {
        when(
          () => mockAuthRepo.register(
            email: 'test@example.com',
            password: 'Password123',
            name: 'John Doe',
          ),
        ).thenAnswer((_) async => MockUserCredential());
        return authCubit;
      },
      act: (cubit) => cubit.register(
        email: 'test@example.com',
        password: 'Password123',
        name: 'John Doe',
      ),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthSuccess>().having((s) => s.hasRole, 'hasRole', false),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthFailure] when register throws CustomException',
      build: () {
        when(
          () => mockAuthRepo.register(
            email: 'test@example.com',
            password: 'Password123',
            name: 'John Doe',
          ),
        ).thenThrow(const CustomException('This email is already in use.'));
        return authCubit;
      },
      act: (cubit) => cubit.register(
        email: 'test@example.com',
        password: 'Password123',
        name: 'John Doe',
      ),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthFailure>().having(
          (s) => s.message,
          'message',
          'This email is already in use.',
        ),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthInitial] when signOut is successful',
      build: () {
        when(() => mockAuthRepo.signOut()).thenAnswer((_) async {});
        return authCubit;
      },
      act: (cubit) => cubit.signOut(),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthInitial>(),
      ],
    );
  });
}
