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
      throw CustomException.fromFirebaseException(e);
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
      throw CustomException.fromFirebaseException(e);
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
      throw CustomException.fromFirebaseException(e);
    } catch (e) {
      if (e is CustomException) rethrow;
      throw CustomException(e.toString());
    }
  }

  Future<void> saveRole(String role) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw const CustomException("User is not logged in.");
    }
    final uid = user.uid;

    await FirebaseFirestore.instance.collection("users").doc(uid).set({
      "uid": uid,
      "email": user.email ?? "",
      "name": user.displayName ?? "",
      "role": role,
    }, SetOptions(merge: true));
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getCurrentUserData() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw const CustomException("User is not logged in.");
    }
    final uid = user.uid;

    return await FirebaseFirestore.instance.collection("users").doc(uid).get();
  }

  Future<void> updateUserProfile({
    required String name,
    String? photoUrl,
    String? phone,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw const CustomException("User is not logged in.");
      }
      final uid = user.uid;

      await user.updateDisplayName(name);
      if (photoUrl != null && photoUrl.isNotEmpty) {
        await user.updatePhotoURL(photoUrl);
      }

      final updateMap = <String, dynamic>{
        "name": name,
        "photoUrl": ?photoUrl,
        "phone": ?phone,
        "updatedAt": FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .set(updateMap, SetOptions(merge: true));
    } on FirebaseAuthException catch (e) {
      throw CustomException.fromFirebaseAuthException(e);
    } on FirebaseException catch (e) {
      throw CustomException.fromFirebaseException(e);
    } catch (e) {
      if (e is CustomException) rethrow;
      throw CustomException(e.toString());
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      final GoogleSignIn googleSignIn = GoogleSignIn();
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }
    } catch (e) {
      throw CustomException(e.toString());
    }
  }
}

