import 'package:firebase_auth/firebase_auth.dart';

class CustomException implements Exception {
  final String message;

  const CustomException(this.message);

  factory CustomException.fromFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return const CustomException('This email is already in use.');

      case 'invalid-email':
        return const CustomException('Please enter a valid email.');

      case 'weak-password':
        return const CustomException('Password is too weak.');

      case 'user-not-found':
        return const CustomException('No user found for this email.');

      case 'wrong-password':
        return const CustomException('Incorrect password.');

      case 'invalid-credential':
        return const CustomException('Invalid email or password.');

      case 'network-request-failed':
        return const CustomException('No internet connection.');

      case 'too-many-requests':
        return const CustomException('Too many attempts. Try again later.');

      default:
        return CustomException(e.message ?? 'Something went wrong.');
    }
  }
}
