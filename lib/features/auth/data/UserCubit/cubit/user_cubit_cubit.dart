import 'package:book_ease/features/auth/data/UserCubit/cubit/user_cubit_state.dart';
import 'package:book_ease/features/auth/data/repo/auth_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserCubit extends Cubit<UserCubitState> {
  UserCubit(this.userRepo) : super(UserCubitInitial());

  final AuthRepo userRepo;

  Future<void> getCurrentUserData() async {
    emit(UserDataLoading());

    try {
      final userData = await userRepo.getCurrentUserData();

      if (userData.exists && userData.data() != null) {
        emit(UserDataLoaded(userData.data()!));
      } else {
        emit(UserDataFailure('User data not found'));
      }
    } catch (e) {
      emit(UserDataFailure(e.toString()));
    }
  }

  Future<void> updateUserProfile({
    required String name,
    String? photoUrl,
    String? phone,
  }) async {
    emit(UserDataLoading());
    try {
      await userRepo.updateUserProfile(
        name: name,
        photoUrl: photoUrl,
        phone: phone,
      );
      await getCurrentUserData();
    } catch (e) {
      emit(UserDataFailure(e.toString()));
    }
  }

  void setUserData(Map<String, dynamic> data) {
    emit(UserDataLoaded(data));
  }

  void clearUserData() {
    emit(UserCubitInitial());
  }
}
