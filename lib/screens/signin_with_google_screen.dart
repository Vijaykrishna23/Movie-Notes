import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_notes/common/google_authentication_provider.dart';
import 'package:provider/provider.dart';

class SignInWithGoogleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print(FirebaseAuth.instance.currentUser);

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Text('Welcome to Movie Notes',
              style:TextStyle(
                fontSize: 30.0,
              ),),
          ),
          Container(
            padding: EdgeInsets.all(32.0),
            child: Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                    minimumSize: Size(double.infinity, 50.0)
                ),
                child: Text("Sign In With Google"),
                onPressed: () {
                  final googleAuthenticationProvider = Provider.of<GoogleAuthenticationProvider>(
                    context,
                    listen: false,
                  );

                  googleAuthenticationProvider.signInUsingGoogle();


                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
