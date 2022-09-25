import 'dart:async';
import 'dart:convert';

import 'package:finder/film.dart';
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
  static eventToMessage(eventString, data) {
    return jsonEncode({'event': eventString, 'data': data});
  }

  static messageToEvent(message) {
    return jsonDecode(message);
  }

  final _incomingChannel = WebSocketChannel.connect(
    Uri.parse('ws://localhost:8001/1'),
  );

  final _outgoingChannel = WebSocketChannel.connect(
    Uri.parse('ws://localhost:8001/1'),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomBuilder.customAppbar(context: context),
      drawer: const Drawer(),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          StatefulBuilder(
              builder: (BuildContext context, StateSetter setState2) {
            return TweenAnimationBuilder<Duration>(
                duration: Duration(seconds: 20),
                tween: Tween(begin: Duration(seconds: 20), end: Duration.zero),
                onEnd: () {
                  print('Timer ended');
                },
                builder: (BuildContext context, Duration value, Widget? child) {
                  final minutes = value.inMinutes;
                  final seconds = value.inSeconds % 60;
                  return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text('$minutes:$seconds',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 30)));
                });
          }),
          StreamBuilder(
              stream: _incomingChannel.stream,
              builder: (context, snapshot) {
                var message = messageToEvent(snapshot.data);
                List<SwipeItem> swipeItems = [];
                List<Film> movies = [];
                if (message['event'] == 'movies') {
                  List<dynamic> movies_data = message['data'];
                  for (var movie_data in movies_data) {
                    List<String> genres = (movie_data['genres'] as List)
                        .map((item) => item as String)
                        .toList(); //;
                    List<int> genre_ids = (movie_data['genre_ids'] as List)
                        .map((item) => item as int)
                        .toList();
                    Film movie = Film(
                        title: movie_data['title'],
                        poster: movie_data['poster'],
                        release_date: movie_data['release_date'],
                        overview: movie_data['overview'],
                        genres: genres,
                        genre_ids: genre_ids);

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
                        onSlideUpdate: (SlideRegion? region) async {
                          print("Region $region");
                        });

                    movies.add(movie);
                    swipeItems.add(swipeItem);
                  }
                }

                MatchEngine matchEngine = MatchEngine(swipeItems: swipeItems);

                return CustomBuilder.buildCards(
                    height: CustomBuilder.customAppbar(context: context)
                        .preferredSize
                        .height,
                    matchEngine: matchEngine,
                    context: context,
                    films: movies);
              })
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
