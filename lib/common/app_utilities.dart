import 'package:firebase_auth/firebase_auth.dart';

class AppUtilities {

  static String getCurrentUserId() {
    return FirebaseAuth.instance.currentUser!.uid;
  }

}