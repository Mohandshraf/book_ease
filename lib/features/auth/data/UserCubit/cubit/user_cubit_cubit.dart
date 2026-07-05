import 'package:bloc/bloc.dart';
import 'package:book_ease/features/auth/data/UserCubit/cubit/user_cubit_state.dart';
import 'package:book_ease/features/auth/data/repo/auth_repo.dart';

class UserCubit extends Cubit<UserCubitState> {
  UserCubit(this.userRepo) : super(UserCubitInitial());

  final AuthRepo userRepo;

  Future<void> getCurrentUserData() async {
    emit(UserDataLoading());

    try {
      final userData = await userRepo.getCurrentUserData();

      emit(UserDataLoaded(userData.data()!));
    } catch (e) {
      emit(UserDataFailure(e.toString()));
    }
  }
}
