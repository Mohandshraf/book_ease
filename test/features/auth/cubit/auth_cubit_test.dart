import 'package:bloc_test/bloc_test.dart';
import 'package:book_ease/core/errors/exceptions/custom_exception.dart';
import 'package:book_ease/features/auth/data/cubit/auth_cubit.dart';
import 'package:book_ease/features/auth/data/cubit/auth_state.dart';
import 'package:book_ease/features/auth/data/repo/auth_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepo extends Mock implements AuthRepo {}
class MockUserCredential extends Mock implements UserCredential {}
// ignore: subtype_of_sealed_class
class MockDocumentSnapshot extends Mock
    implements DocumentSnapshot<Map<String, dynamic>> {}

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

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthSuccess(hasRole: true, role: provider)] when signIn user has provider role',
      build: () {
        final mockDoc = MockDocumentSnapshot();
        when(() => mockDoc.exists).thenReturn(true);
        when(() => mockDoc.data()).thenReturn({
          'uid': '123',
          'email': 'doctor@example.com',
          'role': 'provider',
        });
        when(
          () => mockAuthRepo.signIn(
            email: 'doctor@example.com',
            password: 'Password123',
          ),
        ).thenAnswer((_) async => MockUserCredential());
        when(() => mockAuthRepo.getCurrentUserData())
            .thenAnswer((_) async => mockDoc);
        return authCubit;
      },
      act: (cubit) => cubit.signIn(
        email: 'doctor@example.com',
        password: 'Password123',
      ),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthSuccess>()
            .having((s) => s.hasRole, 'hasRole', true)
            .having((s) => s.userData?['role'], 'role', 'provider'),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthSuccess(hasRole: false)] when signIn user has no role yet',
      build: () {
        final mockDoc = MockDocumentSnapshot();
        when(() => mockDoc.exists).thenReturn(true);
        when(() => mockDoc.data()).thenReturn({
          'uid': '123',
          'email': 'newuser@example.com',
        });
        when(
          () => mockAuthRepo.signIn(
            email: 'newuser@example.com',
            password: 'Password123',
          ),
        ).thenAnswer((_) async => MockUserCredential());
        when(() => mockAuthRepo.getCurrentUserData())
            .thenAnswer((_) async => mockDoc);
        return authCubit;
      },
      act: (cubit) => cubit.signIn(
        email: 'newuser@example.com',
        password: 'Password123',
      ),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthSuccess>()
            .having((s) => s.hasRole, 'hasRole', false)
            .having((s) => s.userData?['role'], 'role', isNull),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthSuccess(hasRole: true)] when saveRole succeeds',
      build: () {
        final mockDoc = MockDocumentSnapshot();
        when(() => mockDoc.exists).thenReturn(true);
        when(() => mockDoc.data()).thenReturn({
          'uid': '123',
          'role': 'provider',
        });
        when(() => mockAuthRepo.saveRole(role: 'provider'))
            .thenAnswer((_) async {});
        when(() => mockAuthRepo.getCurrentUserData())
            .thenAnswer((_) async => mockDoc);
        return authCubit;
      },
      act: (cubit) => cubit.saveRole(role: 'provider'),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthSuccess>()
            .having((s) => s.hasRole, 'hasRole', true)
            .having((s) => s.userData?['role'], 'role', 'provider'),
      ],
    );
  });
}
