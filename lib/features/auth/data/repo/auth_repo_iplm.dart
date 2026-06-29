import 'package:book_ease/core/services/auth_services.dart';
import 'package:book_ease/features/auth/data/repo/auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepoIplm implements AuthRepo {
  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  @override
  Future<UserCredential> register({
    required String email,
    required String password,
  }) {
    return firebaseAuthService.register(email: email, password: password);
  }

  @override
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) {
    return firebaseAuthService.signIn(email: email, password: password);
  }
}
