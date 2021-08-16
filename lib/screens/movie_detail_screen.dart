import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:movie_notes/models/movie.dart';

class MovieDetailScreen extends StatelessWidget {

  final Movie? _movie;


  MovieDetailScreen(this._movie);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("${_movie!.name.toUpperCase()}"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  padding: EdgeInsets.symmetric(vertical: 80, horizontal: 40),
                  child: Column(
                    children: <Widget>[

                      Text(
                        "${_movie!.name.toUpperCase()}",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 40.0,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      //Adding Director name
                      Text(
                        "Directed by ${_movie!.directorName}",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      //Space for poster images
                      Container(
                          constraints: BoxConstraints.expand(height: 500.0),
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Image(
                              image: Image
                                  .memory(base64Decode(_movie!.coverImageUrl))
                                  .image)),

                    ],
                  )),
            ],
          ),
        ));
  }
}