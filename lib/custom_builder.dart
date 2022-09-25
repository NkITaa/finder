import 'package:finder/pages/components.dart';
import 'package:flutter/material.dart';
import 'package:swipe_cards/swipe_cards.dart';

import 'film.dart';

class CustomBuilder {
  static AppBar customAppbar({required BuildContext context}) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              onPressed: () {}, icon: Image.asset("assets/images/logo.png"))
        ],
      ),
      iconTheme: const IconThemeData(color: Colors.black),
      actions: [
        IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.black,
            ),
            onPressed: () {
              showSearch(context: context, delegate: MySearchDelegate());
            })
      ],
    );
  }

  static Widget buildCards(
      {required MatchEngine matchEngine,
      required BuildContext context,
      required List<Film> films,
      required Function onStackFinishedAction,
      required double height}) {
    PageController pageController = PageController(
      initialPage: 0,
      keepPage: true,
    );
    int selectedIndex = 0;

    return Column(children: [
      Container(
        height: MediaQuery.of(context).size.height - height - 5,
        width: MediaQuery.of(context).size.width * 0.95,
        child: SwipeCards(
          matchEngine: matchEngine,
          itemBuilder: (BuildContext context, int index) {
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              void pageChanged(int index) {
                setState(() {
                  selectedIndex = index;
                });
              }

              return Container(
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 248, 248, 248),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                height: MediaQuery.of(context).size.height - height - 5,
                width: MediaQuery.of(context).size.width * 0.95,
                child: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: pageController,
                    onPageChanged: (index) {
                      pageChanged(index);
                    },
                    children: [
                      Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            image: DecorationImage(
                                image: NetworkImage(films[index].poster),
                                fit: BoxFit.cover),
                          ),
                          alignment: Alignment.bottomLeft,
                          child: SizedBox(
                              height: 135,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          films[index].title,
                                          style: const TextStyle(
                                              fontSize: 30,
                                              color: Colors.white),
                                        ),
                                        IconButton(
                                            onPressed: () =>
                                              pageController.animateToPage(
                                                1,
                                                duration: const Duration(
                                                    milliseconds: 300),
                                                curve: Curves.linear,
                                              )
                                            ,
                                            icon: const Icon(
                                              Icons.info_outline,
                                              color: Colors.white,
                                            )),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const Icon(
                                          Icons.date_range,
                                          color: Colors.white,
                                          size: 10,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          films[index].release_date,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
                                          itemCount:
                                              films[index].genres.length > 3
                                                  ? 3
                                                  : films[index].genres.length,
                                          itemBuilder: (context, index2) {
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                index2 == 0
                                                    ? const SizedBox(
                                                        width: 10,
                                                      )
                                                    : Container(),
                                                index2 == 0
                                                    ? const Icon(
                                                        Icons.movie_outlined,
                                                        color: Colors.white,
                                                        size: 10,
                                                      )
                                                    : Container(),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: 5.0,
                                                  ),
                                                  child: Text(
                                                    films[index].genres[index2],
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ],
                                            );
                                          }),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 40,
                                          height: 40,
                                          child: FloatingActionButton(
                                            backgroundColor: Colors.transparent,
                                            shape: const StadiumBorder(
                                                side: BorderSide(
                                                    color: Colors.red,
                                                    width: 1)),
                                            onPressed: () {
                                              matchEngine.currentItem?.nope();
                                            },
                                            child: const Icon(
                                              Icons.close,
                                              size: 30,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        SizedBox(
                                          width: 40,
                                          height: 40,
                                          child: FloatingActionButton(
                                            backgroundColor: Colors.transparent,
                                            shape: const StadiumBorder(
                                                side: BorderSide(
                                                    color: Colors.grey,
                                                    width: 1)),
                                            onPressed: () {
                                              matchEngine.currentItem
                                                  ?.superLike();
                                            },
                                            child: const Icon(
                                              Icons.circle_outlined,
                                              size: 25,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        SizedBox(
                                          width: 40,
                                          height: 40,
                                          child: FloatingActionButton(
                                            backgroundColor: Colors.transparent,
                                            shape: const StadiumBorder(
                                                side: BorderSide(
                                                    color: Color(0xff6EEA95))),
                                            onPressed: () {
                                              matchEngine.currentItem?.like();
                                            },
                                            child: const Icon(
                                              Icons.favorite,
                                              size: 25,
                                              color: Color(0xff6EEA95),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                  ]))),
                      Column(
                        children: [
                          Stack(
                            children: [
                              Column(
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height -
                                        height -
                                        200,
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  const Text("Description",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Color(0xff293133),
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 14.0, right: 14.0),
                                    child: Text(
                                      films[index].overview,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xff293133),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                height: MediaQuery.of(context).size.height -
                                    height -
                                    200,
                                width: MediaQuery.of(context).size.width * 0.95,
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  image: DecorationImage(
                                      //image: NetworkImage(films[index].poster)
                                      image: AssetImage(
                                          "assets/images/example.png"),
                                      fit: BoxFit.cover),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.95,
                                height: 50,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                        onPressed: () =>
                                            pageController.animateToPage(
                                              0,
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              curve: Curves.linear,
                                            ),
                                        icon: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 30,
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      )
                    ]),
              );
            });
          },
          onStackFinished: () {
            onStackFinishedAction();
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Stack Finished"),
              duration: Duration(milliseconds: 500),
            ));
          },
          itemChanged: (SwipeItem item, int index) {
            //print("item: ${item.content.}, index: $index");
          },
          upSwipeAllowed: true,
          fillSpace: true,
        ),
      ),
    ]);
  }

  static Widget addSession({required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Container(
        decoration: const BoxDecoration(
            color: Color.fromARGB(255, 251, 251, 251),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (bounds) => LinearGradient(colors: [
                Colors.blue.shade400,
                Colors.blue.shade900,
              ]).createShader(
                Rect.fromLTWH(0, 0, bounds.width, bounds.height),
              ),
              child: const Text(
                "Boom!",
                style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            const Text(
              "Kreiere eine neue Session",
              style: TextStyle(fontSize: 22),
            ),
            const SizedBox(
              height: 50,
            ),
            SizedBox(
              height: 70,
              width: 70,
              child: FloatingActionButton(
                onPressed: () {},
                child: Ink(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment(0.8, 1),
                      colors: <Color>[
                        Color(0xff005fff),
                        Color(0xfffb00e4),
                      ],
                      tileMode: TileMode.mirror,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(80.0)),
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 70,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
