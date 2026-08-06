import 'package:book_ease/core/errors/exceptions/custom_exception.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
    } on FirebaseException catch (e) {
      throw CustomException(e.message ?? e.toString());
    } catch (e) {
      throw CustomException(e.toString());
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
    } on FirebaseException catch (e) {
      throw CustomException(e.message ?? e.toString());
    } catch (e) {
      throw CustomException(e.toString());
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        throw const CustomException('Google Sign-In was canceled.');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      final userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(userCredential.user!.uid)
            .set({
              "uid": userCredential.user!.uid,
              "name": userCredential.user?.displayName ?? '',
              "email": userCredential.user?.email ?? '',
              "createdAt": FieldValue.serverTimestamp(),
            });
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw CustomException.fromFirebaseAuthException(e);
    } on FirebaseException catch (e) {
      throw CustomException(e.message ?? e.toString());
    } catch (e) {
      if (e is CustomException) rethrow;
      throw CustomException(e.toString());
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
