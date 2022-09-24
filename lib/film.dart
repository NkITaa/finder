import 'dart:core';

class Film {
  String title;
  String poster;
  String releaseDate;
  String overview;
  List<String> genres;

  Film({
    required this.title,
    required this.poster,
    required this.releaseDate,
    required this.overview,
    required this.genres,
  });
}
