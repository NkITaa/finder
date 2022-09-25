import 'package:confetti/confetti.dart';
import 'package:finder/film.dart';
import 'package:flutter/material.dart';
import '../custom_builder.dart';

class WinnerScreen extends StatefulWidget {
  const WinnerScreen({super.key, required this.film});
  final Film film;
  @override
  State<WinnerScreen> createState() => _WinnerScreenState();
}

class _WinnerScreenState extends State<WinnerScreen> {
  bool isPlaying = false;
  bool selected = false;
  late Film film = widget.film;
  final ConfettiController controller = ConfettiController();
  int selectedIndex = 0;
  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );
  void pageChanged(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    controller.play();
    Future.delayed(const Duration(milliseconds: 900), () {
      controller.stop();
      selected = true;
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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
                  const SizedBox(
                    height: 50,
                  ),
                  const Padding(
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
        body: Stack(alignment: Alignment.topCenter, children: [
          Container(
            child: ConfettiWidget(
              confettiController: controller,
              emissionFrequency: 0.50,
              shouldLoop: true,
              blastDirectionality: BlastDirectionality.explosive,
            ),
          ),
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.95,
              child: AnimatedContainer(
                duration: const Duration(seconds: 2),
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 248, 248, 248),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                height: selected
                    ? MediaQuery.of(context).size.height -
                        CustomBuilder.customAppbar(context: context)
                            .preferredSize
                            .height -
                        65
                    : 50,
                width: selected ? MediaQuery.of(context).size.width * 0.95 : 50,
                child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: pageController,
                  onPageChanged: (index) {
                    pageChanged(index);
                  },
                  children: [
                    Container(
                        decoration: selected
                            ? BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20)),
                                image: DecorationImage(
                                    image: NetworkImage(film.poster),
                                    fit: BoxFit.cover),
                              )
                            : BoxDecoration(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                                height: 135,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            film.title,
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
                                                  ),
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
                                            film.release_date,
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
                                            itemCount: film.genres.length > 3
                                                ? 3
                                                : film.genres.length,
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
                                                      film.genres[index2],
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
                                    ])),
                          ],
                        )),
                    Column(
                      children: [
                        Stack(
                          children: [
                            Column(
                              children: [
                                SizedBox(
                                  height: MediaQuery.of(context).size.height -
                                      CustomBuilder.customAppbar(
                                              context: context)
                                          .preferredSize
                                          .height -
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
                                    film.overview,
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
                                  CustomBuilder.customAppbar(context: context)
                                      .preferredSize
                                      .height -
                                  200,
                              width: MediaQuery.of(context).size.width * 0.95,
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20)),
                                image: DecorationImage(
                                    image: NetworkImage(film.poster),
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
                  ],
                ),
              ),
            ),
          )
        ]));
  }
}
