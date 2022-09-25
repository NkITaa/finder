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
  static eventToMessage(eventString, data){
    return jsonEncode({
      'event' : eventString,
      'data' : data
    });
  }

  

  static messageToEvent(message){
    return jsonDecode(message);
  }


  final _incomingChannel= WebSocketChannel.connect(
    Uri.parse('ws://localhost:8001/1'),
  );

  final _outgoingChannel = WebSocketChannel.connect(
    Uri.parse('ws://localhost:8001/1'),
  );
  
  onStackFinishedAction(){
    _incomingChannel.sink.add(eventToMessage('movies', {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomBuilder.customAppbar(context: context),
      drawer: const Drawer(),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          StreamBuilder(
              stream: _incomingChannel.stream,
              builder: (context, snapshot) {
                print('Streambuilder');
                print(snapshot);
                print('data:');
                print(snapshot.data);
                var message = messageToEvent(snapshot.data);
                List<SwipeItem> swipeItems = [];
                List<Film> movies = [];
                if( message['event'] == 'movies'){
                    List<dynamic> movies_data = message['data']['movies'];
                    for (var movie_data in movies_data){

                    List<String> genres = (movie_data['genres'] as List).map((item) => item as String).toList();//;
                    List<int> genre_ids = (movie_data['genre_ids'] as List).map((item) => item as int).toList();
                    Film movie = Film(
                        title: movie_data['title'],
                        poster: movie_data['poster'],
                        release_date: movie_data['release_date'],
                        overview: movie_data['overview'],
                        genres: genres,
                        genre_ids: genre_ids
                      );

                    SwipeItem swipeItem = SwipeItem(
                    content: movie,
                      likeAction: () {
                        print("Likeing a movie");
                        _outgoingChannel.sink.add(eventToMessage('upvote', movie));
                      },
                      nopeAction: () {
                        _outgoingChannel.sink.add(eventToMessage('downvote', movie));
                      },
                      superlikeAction: () {
                        print("Superlike");
                      },
                      onSlideUpdate: (SlideRegion? region) async {
                        print("Region $region");
                      }
                    );

                    movies.add(movie);
                    swipeItems.add(swipeItem);

                    }
                
                }
                print(movies.length);
                
                MatchEngine matchEngine = MatchEngine(swipeItems: swipeItems);


                return CustomBuilder.buildCards(
                    height: CustomBuilder.customAppbar(context: context)
                        .preferredSize
                        .height,
                    matchEngine: matchEngine,
                    context: context,
                    films: movies,
                    onStackFinishedAction: onStackFinishedAction
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
