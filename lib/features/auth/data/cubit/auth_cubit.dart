import 'package:book_ease/core/errors/exceptions/custom_exception.dart';
import 'package:book_ease/features/auth/data/repo/auth_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this.authRepo) : super(AuthInitial());

  final AuthRepo authRepo;

  Future<void> register({
    required String email,
    required String password,
    required String name,
  }) async {
    emit(AuthLoading());

    try {
      await authRepo.register(email: email, password: password, name: name);

      emit(AuthSuccess(hasRole: false));
    } on CustomException catch (e) {
      emit(AuthFailure(e.message));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    emit(AuthLoading());

    try {
      await authRepo.signIn(email: email, password: password);

      final userDoc = await authRepo.getCurrentUserData();

      final hasRole =
          userDoc.exists &&
          userDoc.data() != null &&
          userDoc.data()!["role"] != null;

      emit(AuthSuccess(hasRole: hasRole, userData: userDoc.data()));
    } on CustomException catch (e) {
      emit(AuthFailure(e.message));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> signInWithGoogle() async {
    emit(AuthLoading());

    try {
      await authRepo.signInWithGoogle();

      final userDoc = await authRepo.getCurrentUserData();

      final hasRole =
          userDoc.exists &&
          userDoc.data() != null &&
          userDoc.data()!["role"] != null;

      emit(AuthSuccess(hasRole: hasRole, userData: userDoc.data()));
    } on CustomException catch (e) {
      emit(AuthFailure(e.message));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> saveRole({required String role}) async {
    emit(AuthLoading());

    try {
      await authRepo.saveRole(role: role);
      final userDoc = await authRepo.getCurrentUserData();

      emit(AuthSuccess(hasRole: true, userData: userDoc.data()));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
