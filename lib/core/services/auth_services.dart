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
      await credential.user?.updateDisplayName(name);
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

    await FirebaseFirestore.instance.collection("users").doc(uid).set(
      {
        "uid": uid,
        "role": role,
      },
      SetOptions(merge: true),
    );
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getCurrentUserData() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw const CustomException("User is not logged in.");
    }
    final uid = user.uid;

    // 1. Instant Cache Check (<15ms): If cached locally, return immediately!
    try {
      final cachedDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .get(const GetOptions(source: Source.cache));
      if (cachedDoc.exists && cachedDoc.data() != null) {
        return cachedDoc;
      }
    } catch (_) {
      // Not in local cache yet, proceed to server
    }

    // 2. Fetch from server with a fast timeout (1500ms max)
    DocumentSnapshot<Map<String, dynamic>> doc;
    try {
      doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .get()
          .timeout(const Duration(milliseconds: 1500));
    } catch (_) {
      // 3. If server timed out or offline, try cache one last time
      try {
        doc = await FirebaseFirestore.instance
            .collection("users")
            .doc(uid)
            .get(const GetOptions(source: Source.cache));
      } catch (_) {
        rethrow;
      }
    }

    // If Firestore doc has empty name but Firebase Auth displayName exists, sync it
    if (doc.exists) {
      final currentDocName = doc.data()?['name'] as String?;
      if (currentDocName == null || currentDocName.trim().isEmpty) {
        final displayName = user.displayName;
        if (displayName != null && displayName.trim().isNotEmpty) {
          try {
            FirebaseFirestore.instance
                .collection("users")
                .doc(uid)
                .set({"name": displayName.trim()}, SetOptions(merge: true));
          } catch (_) {}
        }
      }
    }

    return doc;
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

