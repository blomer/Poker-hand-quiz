import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:poker_hand_test/hand_detector.dart';

void main() {
  test("poker hand test", () {
    PokerHand ph = PokerHandDetector.detectHand(["4h", "2c", "3h", "5s", "ac"]);
    print(ph.toString());
  });

  test("deck with hands", () {
    List<String> usedCards = [], board = [], hand1 = [], hand2 = [];

    for(int i = 0; i < 5; i++) {
      String card = generateCard(usedCards);

      board.add(card);
      usedCards.add(card);
    }

    for(int cards = 0; cards < 2; cards++) {
      String card = generateCard(usedCards);

      hand1.add(card);
      usedCards.add(card);
    }

    for(int cards = 0; cards < 2; cards++) {
      String card = generateCard(usedCards);

      hand2.add(card);
      usedCards.add(card);
    }

    var hand1phd = PokerHandDetector.bestHandNoLimits(board, hand1);
    var hand2phd = PokerHandDetector.bestHandNoLimits(board, hand2);

    int bestHand = hand1phd!.compareTo(hand2phd);

    if(bestHand > 0) {
      print("Player 1 won with ${hand1phd.type}");
    } else {
      print("Player 2 won with ${hand2phd?.type}");
    }

    print("Board: $board");
    print("Player 1 Hand: $hand1");
    print("Player 2 Hand: $hand2");
  });

  test("poker compare test", () {
    List<String> board = ["4h", "2c", "3h", "5s", "9c"];
    List<String> player1cards = ["6c", "7c"];
    List<String> player2cards = ["ac", "kd"];

    var hand1 = PokerHandDetector.bestHandNoLimits(board, player1cards);
    var hand2 = PokerHandDetector.bestHandNoLimits(board, player2cards);

    int bestHand = hand1!.compareTo(hand2);

    if(bestHand > 0) {
      print("Player 1 won with ${hand1.type}");
    } else {
      print("Player 2 won with ${hand2?.type}");
    }

    List<String> cards = [];

    for(int i = 0; i < 5; i++) {
      String rank = PokerHandDetector.FACES.elementAt(Random().nextInt(13));
      String suit = PokerHandDetector.SUITS.elementAt(Random().nextInt(4));

      if(cards.contains(rank + suit)) {
        i--;
      } else {
        cards.add(rank + suit);
      }
    }

    print(cards);
  });
}

String generateCard(List<String> usedCards) {
  while(true) {
    String card = PokerHandDetector.FACES.elementAt(Random().nextInt(13)) + PokerHandDetector.SUITS.elementAt(Random().nextInt(4));
    if(!usedCards.contains(card)) {
      return card;
    }
  }
}