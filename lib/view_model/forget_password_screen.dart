import 'package:firebase_auth/firebase_auth.dart';

class ForgetPasswordViewModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<PasswordResetResult> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return PasswordResetResult.success('Password Reset Email has been sent!');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return PasswordResetResult.failure('No user found for that Email');
      }
      return PasswordResetResult.failure('An error occurred: ${e.message}');
    }
  }
}

class PasswordResetResult {
  final bool success;
  final String message;

  PasswordResetResult._(this.success, this.message);

  factory PasswordResetResult.success(String message) => PasswordResetResult._(true, message);
  factory PasswordResetResult.failure(String message) => PasswordResetResult._(false, message);
}
