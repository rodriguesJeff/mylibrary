import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<LoginStatus> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return LoginStatus.genericError;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);

      return LoginStatus.success;
    } catch (e) {
      log("Erro ao logar com Google no Android: $e");
      return LoginStatus.genericError;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}

enum CreationAccountStatus {
  created,
  passwordWeak,
  alreadyExists,
  genericError,
}

enum LoginStatus {
  success,
  userNotFound,
  wrongPassword,
  genericError,
}
