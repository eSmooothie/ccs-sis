import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSingInProvider extends ChangeNotifier {
  GoogleSignIn _googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _account;

  GoogleSignInAccount get user => _account!;

  Future googleLogin() async {
    try {
      GoogleSignInAccount? googleAccount = await _googleSignIn.signIn();
      if (googleAccount == null) return;
      _account = googleAccount;

      GoogleSignInAuthentication googleAuth =
          await googleAccount.authentication;

      OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print(e.toString());
    }

    notifyListeners();
  }

  Future googleLogout() async {
    await _googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }
}
