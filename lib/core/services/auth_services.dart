import 'package:book_ease/core/errors/exceptions/custom_exception.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> register({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
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
}
