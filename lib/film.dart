import 'dart:core';

class Film {
  String title;
  String poster;
  String release_date;
  String overview;
  List<String> genres;

  Film({
    required this.title,
    required this.poster,
    required this.release_date,
    required this.overview,
    required this.genres,
  });
}
