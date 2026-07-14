import 'package:book_ease/core/errors/exceptions/custom_exception.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await FirebaseFirestore.instance
          .collection("users")
          .doc(credential.user!.uid)
          .set({
            "uid": credential.user!.uid,
            "name": name,
            "email": email,
            "createdAt": FieldValue.serverTimestamp(),
          });

      return credential;
    } on FirebaseAuthException catch (e) {
      throw CustomException.fromFirebaseAuthException(e);
    } catch (_) {
      throw const CustomException('Something went wrong. Please try again.');
    }
  }

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw CustomException.fromFirebaseAuthException(e);
    } catch (_) {
      throw const CustomException('Something went wrong. Please try again.');
    }
  }

  Future<void> saveRole(String role) async {
    final uid = _auth.currentUser!.uid;

    await FirebaseFirestore.instance.collection("users").doc(uid).update({
      "role": role,
    });
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getCurrentUserData() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return await FirebaseFirestore.instance.collection("users").doc(uid).get();
  }
}
