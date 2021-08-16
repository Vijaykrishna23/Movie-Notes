import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthenticationProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  Future signInUsingGoogle() async {
    final emailChosenByUser = await googleSignIn.signIn();

    if (emailChosenByUser == null) return;
    _user = emailChosenByUser;

    final googleSignInAuthentication = await emailChosenByUser.authentication;

    final googleSignInCredential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(googleSignInCredential);

    notifyListeners();
  }

  Future signOut() async {
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }
}
