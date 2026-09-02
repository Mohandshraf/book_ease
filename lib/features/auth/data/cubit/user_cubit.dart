import 'package:book_ease/features/auth/data/cubit/user_state.dart';
import 'package:book_ease/features/auth/data/repo/auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

export 'user_state.dart';

class UserCubit extends Cubit<UserCubitState> {
  UserCubit(this.userRepo) : super(const UserCubitInitial());

  final AuthRepo userRepo;

  Future<void> getCurrentUserData({bool emitLoading = true}) async {
    if (emitLoading && state is! UserDataLoaded) {
      emit(const UserDataLoading());
    }

    try {
      final userDoc = await userRepo.getCurrentUserData();
      final currentUser = FirebaseAuth.instance.currentUser;

      if (userDoc.exists && userDoc.data() != null) {
        final data = Map<String, dynamic>.from(userDoc.data()!);
        final docName = data['name'];
        if (docName == null || docName.toString().trim().isEmpty) {
          if (currentUser?.displayName != null &&
              currentUser!.displayName!.trim().isNotEmpty) {
            data['name'] = currentUser.displayName!.trim();
          }
        }
        emit(UserDataLoaded(data));
      } else if (currentUser != null) {
        final fallbackData = <String, dynamic>{
          'uid': currentUser.uid,
          'email': currentUser.email ?? '',
          'name': currentUser.displayName ?? 'User',
          'photoUrl': currentUser.photoURL,
        };
        emit(UserDataLoaded(fallbackData));
      } else {
        emit(const UserDataFailure('User data not found'));
      }
    } catch (e) {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final fallbackData = <String, dynamic>{
          'uid': currentUser.uid,
          'email': currentUser.email ?? '',
          'name': (currentUser.displayName != null &&
                  currentUser.displayName!.trim().isNotEmpty)
              ? currentUser.displayName!.trim()
              : 'User',
          'photoUrl': currentUser.photoURL,
          'role': 'customer',
        };
        emit(UserDataLoaded(fallbackData));
      } else {
        emit(UserDataFailure(e.toString()));
      }
    }
  }

  Future<void> updateUserProfile({
    required String name,
    String? photoUrl,
    String? phone,
  }) async {
    try {
      await userRepo.updateUserProfile(
        name: name,
        photoUrl: photoUrl,
        phone: phone,
      );
      await getCurrentUserData(emitLoading: false);
    } catch (e) {
      emit(UserDataFailure(e.toString()));
    }
  }

  void setUserData(Map<String, dynamic> data) {
    emit(UserDataLoaded(data));
  }

  void clearUserData() {
    emit(const UserCubitInitial());
  }
}
