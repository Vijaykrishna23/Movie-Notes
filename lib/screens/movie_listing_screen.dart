import 'package:flutter/material.dart';
import 'package:movie_notes/common/database_helper.dart';
import 'package:movie_notes/common/google_authentication_provider.dart';
import 'package:movie_notes/models/movie.dart';
import 'package:movie_notes/screens/add_update_movie_screen.dart';
import 'package:provider/provider.dart';

import 'movie_detail_screen.dart';

class MovieListingScreen extends StatefulWidget {
  @override
  _MovieListingScreenState createState() {
    return _MovieListingScreenState();
  }
}

class _MovieListingScreenState extends State<MovieListingScreen> {
  Future<List<Movie>>? _movieList;

  @override
  void initState() {
    super.initState();
    _updateMovieList();
  }

  void _updateMovieList() {
    setState(() {
      _movieList = DataBaseHelper.instance.getAllMoviesForCurrentUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Movies List"),
        actions: <Widget>[
          TextButton(
            child: Text("Sign Out", style: TextStyle(
              color: Colors.white,
              fontSize: 15.0,
            ),),
            onPressed: () {
              final provider = Provider.of<GoogleAuthenticationProvider>(context,listen: false);
              provider.signOut();
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Movie>>(
        initialData: [],
        future: _movieList,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if(snapshot.data!.length==0) {
            return Container(
              padding: EdgeInsets.all(32.0),
              child: Center(
                child: Text(
                    "Press the add icon on the bottom right of the screen to add movies.",
                  style: TextStyle(
                    fontSize: 15.0,
                ),textAlign: TextAlign.justify,),
              ),
            );
          }
          return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) =>
                  buildIndividualRow(snapshot.data![index]));
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddUpdateMovieScreen(movie: null)));
          _updateMovieList();
        },
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget buildIndividualRow(Movie? movie) {
    return Container(
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.all(20.0),
      decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
      child: ListTile(
        title: Text(movie!.name ,
        style: TextStyle(
          fontWeight: FontWeight.w500,
        ),),
        trailing: Wrap(
          spacing: 20.0,
          children: [
            GestureDetector(
              child: Icon(Icons.edit),
              onTap: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AddUpdateMovieScreen(movie: movie)));
                _updateMovieList();
              },
            ),
            GestureDetector(
              child: Icon(Icons.delete),
              onTap: () async {
                await DataBaseHelper.instance.deleteMovie(movie.id);
                _updateMovieList();
              },
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MovieDetailScreen(movie)));
          _updateMovieList();
        },
      ),
    );
  }
}
