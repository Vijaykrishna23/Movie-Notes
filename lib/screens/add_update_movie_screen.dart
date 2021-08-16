import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_notes/common/database_helper.dart';
import 'package:movie_notes/models/movie.dart';

class AddUpdateMovieScreen extends StatefulWidget {
  const AddUpdateMovieScreen({Key? key, required this.movie}) : super(key: key);

  final Movie? movie;

  @override
  State<AddUpdateMovieScreen> createState() {
    return AddUpdateMovieScreenState(movie);
  }
}

class AddUpdateMovieScreenState extends State<AddUpdateMovieScreen> {
  final _formKey = GlobalKey<FormState>();
  final Movie? movie;
  final userId = FirebaseAuth.instance.currentUser!.uid;

  String? name;
  String? directorName;
  String? imageUrl;

  AddUpdateMovieScreenState(this.movie);

  @override
  void initState() {
    super.initState();
    if (movie != null) {
      setState(() {
        name = movie!.name;
        directorName = movie!.directorName;
        imageUrl = movie!.coverImageUrl;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
          appBar: AppBar(
            title: movie==null ? Text("Add New Movie") : Text("Edit Movie"),
          ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            spacing: 20.0,
            children: <Widget>[
              const SizedBox(height: 20.0),
              buildNameField(),
              const SizedBox(height: 32.0),
              buildDirectorNameField(),
              const SizedBox(height: 32.0),
              buildChooseImageButtonField(),
              const SizedBox(height: 32.0),
              buildShowImageField(),
              const SizedBox(height: 32.0),
              buildAddUpdateButtonField(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNameField() {
    return TextFormField(
        decoration: InputDecoration(
            labelText: "Movie Name", border: OutlineInputBorder()),
        initialValue: name,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Name is required';
          }
          return null;
        },
        onSaved: (value) => name = value);
  }

  Widget buildDirectorNameField() {
    return TextFormField(
        decoration: InputDecoration(
            labelText: "Director Name", border: OutlineInputBorder()),
        initialValue: directorName,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Director Name is required';
          }
          return null;
        },
        onSaved: (value) => directorName = value);
  }

  Widget buildChooseImageButtonField() {
    return Row(
      children: <Widget>[
        OutlinedButton(
          child: Text('Choose Image'),
          onPressed: () {
            pickImageFromGallery();
          },
        )
      ],
    );
  }

  Widget buildShowImageField() {
    Widget child;
    if (imageUrl == null) {
      child = Text('No Image selected');
    } else {
      child = Image(
          image: Image.memory(base64Decode(imageUrl!)).image, height: 200.0);
    }

    return Row(
      children: [
        Container(
          child: child,
        ),
      ],
    );
  }

  Widget buildAddUpdateButtonField() {
    return Container(
      width: double.infinity,
      height: 50.0,
      child: ElevatedButton(
        child: movie == null ? Text('Add') : Text('Update'),
        onPressed: () {

          final isFormValid = _formKey.currentState!.validate();

          if (isFormValid && imageUrl != null) {
            _formKey.currentState!.save();

            Movie updatedMovie = Movie(name!, directorName!, imageUrl!, userId);

            if (movie == null) {
              insertMovieAndMoveBackToListingScreen(updatedMovie);
            } else {
              updatedMovie.id = movie!.id;
              updateMovieAndMoveBackToListingScreen(updatedMovie);
            }

          } else {
            SnackBar snackBar = SnackBar(
                content: Text('All Fields are required'),
                padding: EdgeInsets.all(32.0));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
      ),
    );
  }

  Future pickImageFromGallery() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage == null) return;

    setState(() {
      imageUrl = base64Encode(File(pickedImage.path).readAsBytesSync());
    });
  }

  Future insertMovieAndMoveBackToListingScreen(Movie movie) async {
    await DataBaseHelper.instance.insertMovie(movie);
    Navigator.pop(context);
  }

  Future updateMovieAndMoveBackToListingScreen(Movie movie) async {
    await DataBaseHelper.instance.updateMovie(movie);
    Navigator.pop(context);
  }
}
