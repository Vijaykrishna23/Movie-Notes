/// Model class for Movie. The fields acts as columns in the movie table.

class Movie {
  int? id;
  String name;
  String directorName;
  String coverImageUrl;
  String userId;

  /// Default constructor. Doesn't initialize id.
  Movie(this.name, this.directorName, this.coverImageUrl, this.userId);

  /// Named constructor to instantiate the object with Id
  Movie.withId(
      this.id, this.name, this.directorName, this.coverImageUrl, this.userId);

  /// Function to convert the current object to type of map of strings.
  /// This map is the only datatype that can be stored in the database.

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    if (id != null) map['id'] = id;
    map['name'] = name;
    map['director_name'] = directorName;
    map['cover_image'] = coverImageUrl;
    map['user_id'] = userId;

    return map;
  }

  /// Another named constructor. Takes in the map and returns the corresponding movie object.
  /// This function is used when retreiving data from database and returning to handle UI stuff.

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie.withId(map['id'], map['name'], map['director_name'],
        map['cover_image'], map['user_id']);
  }
}
