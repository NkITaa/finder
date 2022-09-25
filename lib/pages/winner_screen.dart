import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

import '../custom_builder.dart';

class WinnerScreen extends StatefulWidget {
  const WinnerScreen({super.key});

  @override
  State<WinnerScreen> createState() => _WinnerScreenState();
}

class _WinnerScreenState extends State<WinnerScreen> {
  bool isPlaying = false;

  final ConfettiController controller = ConfettiController();

  @override
  void initState() {
    super.initState();
    controller.play();
    Future.delayed(const Duration(milliseconds: 900), () {
      controller.stop();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          appBar: CustomBuilder.customAppbar(context: context),
          drawer: const Drawer(),
          body: ConfettiWidget(
            confettiController: controller,
            emissionFrequency: 0.50,
            shouldLoop: true,
            blastDirectionality: BlastDirectionality.explosive,
          ),
        ),
      ],
    );
  }
}
