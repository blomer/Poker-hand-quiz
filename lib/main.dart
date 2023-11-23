import 'dart:math';

import 'package:flutter/material.dart';
import 'package:poker_hand_test/player_hand.dart';

import 'hand_detector.dart';

List<String> board = [];
List<PlayerHand> playerHands = [];
String result = "Please choose which hand wins.";
int roundsPlayed = 0, correctAnswers = 0;

void main() {
  generateHand();
  runApp(MaterialApp(home: Home()));
}

void generateHand() {

  board.clear();
  playerHands.clear();

  List<String> usedCards = [], one = [], two = [];
  for(int i = 0; i < 5; i++) {

    String card = generateCard(usedCards);
    board.add(card);
    usedCards.add(card);
  }

  for(int players = 0; players < 3; players++) {
    List<String> hand = [];
    for(int cards = 0; cards < 2; cards++) {
      String card = generateCard(usedCards);

      hand.add(card);
      usedCards.add(card);
    }

    playerHands.add(PlayerHand(cards: hand));
  }
}

String generateCard(List<String> usedCards) {
  while(true) {
    String card = PokerHandDetector.FACES.elementAt(Random().nextInt(13)) + PokerHandDetector.SUITS.elementAt(Random().nextInt(4));
    if(!usedCards.contains(card)) {
      return card;
    }
  }
}

class Results extends StatelessWidget {
  const Results({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      appBar: AppBar(
        centerTitle: true,
        title: Text(
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
            Text("Game Finished!", style: TextStyle(
              fontSize: 24,
              color: Colors.white,
            ),),
            Text("Correct answers: $correctAnswers/$roundsPlayed", style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),),
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

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      appBar: AppBar(
        centerTitle: true,
        title: Text(
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
            Text(result, style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),),
            Text("Correct answers: $correctAnswers/$roundsPlayed"),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: board.map((e) => Image.asset("assets/cards/$e.png", scale: 1.75)).toList(),
            ),
            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: playerHands.map((hand) =>
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    onPressed: (){
                      setState(() {
                        List<String> fullHand = List.from(board);
                        fullHand.addAll(hand.cards);

                        PokerHand pokerHand = PokerHandDetector.detectHand(fullHand);

                        bool isBestHand = true;
                        for(PlayerHand h in playerHands) {
                          if (h.cards != hand.cards) {
                            var hand1 = PokerHandDetector.bestHandNoLimits(
                                board, hand.cards);
                            var hand2 = PokerHandDetector.bestHandNoLimits(
                                board, h.cards);

                            int i = hand1!.compareTo(hand2);
                            if (i < 0) {
                              isBestHand = false;
                              break;
                            }
                          }
                        }

                        if(isBestHand) {
                          result = "That was the best hand! ${pokerHand.type.name}";
                          correctAnswers++;
                        } else {
                          result = "That was not the best hand. :(";
                        }

                        roundsPlayed++;
                      });

                      Future.delayed(const Duration(seconds: 1), () {
                        setState(() {
                          if(roundsPlayed > 9) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const Results()),
                            );
                            roundsPlayed = 0;
                            correctAnswers = 0;
                          } else {
                            generateHand();
                          }
                        });
                      });
                    },
                  icon: Row(
                    children: [
                      Image.asset("assets/cards/${hand.cards.elementAt(0)}.png", scale: 1.75),
                      Image.asset("assets/cards/${hand.cards.elementAt(1)}.png", scale: 1.75)
                    ],
                    ),
                    padding: EdgeInsets.all(0),
                    splashRadius: 1
                  ),
                )).toList(),
            )
          ],
        ),
      ),
    );
  }
}
