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
    } catch (_) {
      emit(AuthFailure('Something went wrong. Please try again.'));
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

      emit(AuthSuccess(hasRole: hasRole));
    } on CustomException catch (e) {
      emit(AuthFailure(e.message));
    } catch (_) {
      emit(AuthFailure('Something went wrong. Please try again.'));
    }
  }

  Future<void> saveRole({required String role}) async {
    emit(AuthLoading());

    try {
      await authRepo.saveRole(role: role);

      emit(AuthSuccess(hasRole: true));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
