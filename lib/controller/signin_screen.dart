import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whisper/models/user_model.dart';

class SignInResult {
  final String? errorMessage;
  final UserModel? user;

  SignInResult({this.errorMessage, this.user});
}

class SignInController {
  Future<SignInResult> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      final String uid = userCredential.user!.uid;

      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (!userDoc.exists) {
        return SignInResult(
            errorMessage: 'User record not found in Firestore.');
      }

      final userModel = UserModel.fromJson({
        ...userDoc.data() as Map<String, dynamic>,
        'docId': userDoc.id,
      });

      return SignInResult(user: userModel);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return SignInResult(errorMessage: 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        return SignInResult(errorMessage: 'Wrong password provided.');
      } else {
        return SignInResult(errorMessage: 'Authentication failed.');
      }
    } catch (e) {
      return SignInResult(errorMessage: 'An unexpected error occurred.');
    }
  }
}
