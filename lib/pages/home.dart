import 'package:finder/film.dart';
import 'package:flutter/material.dart';
import 'package:swipe_cards/draggable_card.dart';
import 'package:swipe_cards/swipe_cards.dart';

import '../custom_builder.dart';

GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  MatchEngine matchEngine = MatchEngine(swipeItems: [
    SwipeItem(
        content: "Anup Kumar Panwar",
        likeAction: () {
          print("Like");
        },
        nopeAction: () {
          print("Nope");
        },
        superlikeAction: () {
          print("Superlike");
        },
        onSlideUpdate: (SlideRegion? region) async {
          print("Region $region");
        })
  ]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomBuilder.customAppbar(context: context),
      drawer: const Drawer(),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          CustomBuilder.buildCards(
            height: CustomBuilder.customAppbar(context: context)
                .preferredSize
                .height,
            matchEngine: matchEngine,
            context: context,
            films: [
              Film(
                  title: "Spider Man",
                  poster: "poster",
                  releaseDate: "12.10.2001",
                  overview:
                      "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.",
                  genres: ["genres"])
            ],
          )
        ]),
      ),
    );
  }
}
