import 'package:book_ease/core/services/auth_services.dart';
import 'package:book_ease/features/auth/data/repo/auth_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepoImpl implements AuthRepo {
  final FirebaseAuthService _firebaseAuthService;

  AuthRepoImpl([FirebaseAuthService? firebaseAuthService])
      : _firebaseAuthService = firebaseAuthService ?? FirebaseAuthService();

  @override
  Future<UserCredential> register({
    required String email,
    required String password,
    required String name,
  }) {
    return _firebaseAuthService.register(
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
    return _firebaseAuthService.signIn(email: email, password: password);
  }

  @override
  Future<UserCredential> signInWithGoogle() {
    return _firebaseAuthService.signInWithGoogle();
  }

  @override
  Future<void> saveRole({required String role}) {
    return _firebaseAuthService.saveRole(role);
  }

  @override
  Future<DocumentSnapshot<Map<String, dynamic>>> getCurrentUserData() {
    return _firebaseAuthService.getCurrentUserData();
  }

  @override
  Future<void> updateUserProfile({
    required String name,
    String? photoUrl,
    String? phone,
  }) {
    return _firebaseAuthService.updateUserProfile(
      name: name,
      photoUrl: photoUrl,
      phone: phone,
    );
  }

  @override
  Future<void> signOut() {
    return _firebaseAuthService.signOut();
  }
}

// Backwards compatibility alias
typedef AuthRepoIplm = AuthRepoImpl;
