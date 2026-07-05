import 'package:cloud_firestore/cloud_firestore.dart';
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
  Future<void> saveRole({required String role});
  Future<DocumentSnapshot<Map<String, dynamic>>> getCurrentUserData();
}
