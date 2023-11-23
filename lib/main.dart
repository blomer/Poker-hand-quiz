import 'dart:math';

import 'package:flutter/material.dart';
import 'package:poker_hand_test/flutter_flux/flutter_flux.dart';
import 'package:poker_hand_test/game_store.dart';
import 'package:poker_hand_test/player_hand.dart';

import 'hand_detector.dart';

void main() {
  runApp(MaterialApp(home: Home()));
}

class Results extends StatelessWidget {
  final int correctAnswers, roundsPlayed;

  const Results({
    required this.correctAnswers,
    required this.roundsPlayed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Poker Hand Quiz",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Game Finished!",
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
            Text(
              "Correct answers: $correctAnswers/$roundsPlayed",
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with StoreWatcherMixin<Home> {
  late GameStore gameStore;

  @override
  void initState() {
    super.initState();

    gameStore = listenToStore(gameStoreToken) as GameStore;
    gameStoreActions.generateHand();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> handButtons = [];

    for (var i = 0; i < gameStore.playerHands.length; ++i) {
      PlayerHand hand = gameStore.playerHands[i];
      handButtons.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: IconButton(
            onPressed: () {
              gameStoreActions.captureUserSelection(i);

              Future.delayed(const Duration(seconds: 1), () {
                setState(() {
                  if (gameStore.roundsPlayed > 9) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Results(roundsPlayed: gameStore.roundsPlayed, correctAnswers: gameStore.correctAnswers,)),
                    );
                  } else {
                    gameStoreActions.generateHand();
                  }
                });
              });
            },
            icon: Row(
              children: [
                Image.asset(
                    "assets/cards/${hand.cards.elementAt(0)}.png",
                    scale: 1.75),
                Image.asset(
                    "assets/cards/${hand.cards.elementAt(1)}.png",
                    scale: 1.75)
              ],
            ),
            padding: EdgeInsets.all(0),
            splashRadius: 1),
      ));
    }

    return Scaffold(
      backgroundColor: Colors.blue[900],
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Poker Hand Quiz",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              gameStore.result,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            Text(
                "Correct answers: ${gameStore.correctAnswers}/${gameStore.roundsPlayed}"),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: gameStore.board
                  .map((e) => Image.asset("assets/cards/$e.png", scale: 1.75))
                  .toList(),
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: handButtons,
            )
          ],
        ),
      ),
    );
  }
}
