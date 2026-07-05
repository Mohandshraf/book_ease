import 'package:book_ease/core/services/auth_services.dart';
import 'package:book_ease/features/auth/data/repo/auth_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepoIplm implements AuthRepo {
  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  @override
  Future<UserCredential> register({
    required String email,
    required String password,
    required String name,
  }) {
    return firebaseAuthService.register(
      email: email,
      password: password,
      name: name,
    );
  }

  @override
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) {
    return firebaseAuthService.signIn(email: email, password: password);
  }

  @override
  Future<void> saveRole({required String role}) {
    return firebaseAuthService.saveRole(role);
  }

  @override
  Future<DocumentSnapshot<Map<String, dynamic>>> getCurrentUserData() {
    return firebaseAuthService.getCurrentUserData();
  }
}
