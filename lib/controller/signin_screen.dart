import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInResult {
  final String? errorMessage;
  final String? fullName;
  final String? email;

  SignInResult({this.errorMessage, this.fullName, this.email});
}

class SignInController {
  Future<SignInResult> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (userDoc.exists) {
        return SignInResult(
          fullName: userDoc.get('fullName'),
          email: userDoc.get('email'),
        );
      } else {
        return SignInResult(errorMessage: 'User data not found.');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return SignInResult(errorMessage: 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        return SignInResult(errorMessage: 'Wrong password provided.');
      } else {
        return SignInResult(errorMessage: 'Something went wrong.');
      }
    }
  }
}
