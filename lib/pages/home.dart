import 'dart:async';
import 'dart:convert';

import 'package:finder/film.dart';
import 'package:finder/pages/winner_screen.dart';
import 'package:flutter/material.dart';
import 'package:swipe_cards/draggable_card.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../custom_builder.dart';

GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double? session_time_remaining;
  Film? winner;

  static eventToMessage(eventString, data) {
    return jsonEncode({'event': eventString, 'data': data});
  }

  static messageToEvent(message) {
    return jsonDecode(message);
  }

  static movieDataToFilm(movie_data) {
    List<String> genres = (movie_data['genres'] as List)
        .map((item) => item as String)
        .toList(); //;
    List<int> genre_ids =
        (movie_data['genre_ids'] as List).map((item) => item as int).toList();
    Film movie = Film(
        title: movie_data['title'],
        poster: movie_data['poster'],
        release_date: movie_data['release_date'],
        overview: movie_data['overview'],
        genres: genres,
        genre_ids: genre_ids);
    return movie;
  }

  static String host = 'wss://starfish-app-9pr9f.ondigitalocean.app/2022';
  final _incomingChannel = WebSocketChannel.connect(
    Uri.parse(host),
  );

  final _outgoingChannel = WebSocketChannel.connect(
    Uri.parse(host),
  );

  onStackFinishedAction() {
    _incomingChannel.sink.add(eventToMessage('movies', {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomBuilder.customAppbar(context: context),
      drawer: Drawer(
          child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color(0xfffb00e4),
                Color(0xff005fff),
              ],
            )),
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    "Stop watching movies, read books ;)",
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Icon(
                  Icons.book_outlined,
                  size: 80,
                  color: Colors.white,
                )
              ],
            ),
          ),
        ],
      )),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          StreamBuilder(
            stream: _incomingChannel.stream,
            builder: (context, snapshot) {
              var message = messageToEvent(snapshot.data);
              List<SwipeItem> swipeItems = [];
              List<Film> movies = [];
              if (message['event'] == 'result') {
                winner = movieDataToFilm(message['data']);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WinnerScreen(
                            film: winner!,
                          )),
                );
              }
              if (message['event'] == 'movies') {
                List<dynamic> movies_data = message['data']['movies'];
                session_time_remaining =
                    message['data']['session_time_remaining'];
                for (var movie_data in movies_data) {
                  Film movie = movieDataToFilm(movie_data);
                  SwipeItem swipeItem = SwipeItem(
                      content: movie,
                      likeAction: () {
                        _outgoingChannel.sink
                            .add(eventToMessage('upvote', movie));
                      },
                      nopeAction: () {
                        _outgoingChannel.sink
                            .add(eventToMessage('downvote', movie));
                      },
                      superlikeAction: () {},
                      onSlideUpdate: (SlideRegion? region) async {});

                  movies.add(movie);
                  swipeItems.add(swipeItem);
                }
              }
              MatchEngine matchEngine = MatchEngine(swipeItems: swipeItems);
              return Column(
                children: [
                  TweenAnimationBuilder<Duration>(
                      duration:
                          Duration(seconds: (session_time_remaining!).toInt()),
                      tween: Tween(
                          begin: Duration(
                              seconds: (session_time_remaining!).toInt()),
                          end: Duration.zero),
                      onEnd: () {},
                      builder: (BuildContext context, Duration value,
                          Widget? child) {
                        return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text('${value.inSeconds}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30)));
                      }),
                  CustomBuilder.buildCards(
                      height: CustomBuilder.customAppbar(context: context)
                          .preferredSize
                          .height,
                      matchEngine: matchEngine,
                      context: context,
                      films: movies,
                      onStackFinishedAction: onStackFinishedAction),
                ],
              );
            },
          )
        ]),
      ),
    );
  }

  @override
  void dispose() {
    _incomingChannel.sink.close();

    super.dispose();
  }
}
