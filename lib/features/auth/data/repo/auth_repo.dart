import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepo {
  Future<UserCredential> register({
    required String email,
    required String password,
    required String name,
  });

  Future<UserCredential> signIn({
    required String email,
    required String password,
  });
}
