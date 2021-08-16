import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_notes/common/google_authentication_provider.dart';
import 'package:movie_notes/main.dart';
import 'package:movie_notes/screens/movie_listing_screen.dart';
import 'package:movie_notes/screens/signin_with_google_screen.dart';
import 'package:provider/provider.dart';

class FirstScreenHandlerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context)  => Scaffold(

      body: StreamBuilder(

        stream: FirebaseAuth.instance.authStateChanges(),

        builder: (context,snapshot) {

          if(snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
          }
          else if(snapshot.hasError){
            return Center(child: Text("Something went wrong!"));
          }
          else if(snapshot.hasData) {
            return MovieListingScreen();
          }
          else {
            return SignInWithGoogleScreen();
          }

          return MyHomePage(title: "title");

        }
      ),


  );
}