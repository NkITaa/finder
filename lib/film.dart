import 'dart:core';

class Film {
  String title;
  String poster;
  String release_date;
  String overview;
  List<String> genres;
  List<int> genre_ids;

  Film({
    required this.title,
    required this.poster,
    required this.release_date,
    required this.overview,
    required this.genres,
    required this.genre_ids,
  });

  Map<String, dynamic> toJson(){
    return {
      'title' : title,
      'poster': poster,
      'release_data': release_date,
      'overview' : overview,
      'genres': genres,
      'genre_ids': genre_ids
    };
  }
}
