import 'dart:core';
import 'dart:math';

import 'package:poker_hand_test/player_hand.dart';

import 'hand_detector.dart';

class GameState {
  final List<String> board;
  final List<PlayerHand> playerHands;
  final String result;
  final int roundsPlayed;
  final int correctAnswers;

  GameState._({
    required this.board,
    required this.playerHands,
    required this.result,
    required this.roundsPlayed,
    required this.correctAnswers,
  });

  GameState copyWith({
    List<String>? board,
    List<PlayerHand>? playerHands,
    String? result,
    int? roundsPlayed,
    int? correctAnswers,
  }) {
    return GameState._(
      board: board ?? this.board,
      playerHands: playerHands ?? this.playerHands,
      result: result ?? this.result,
      roundsPlayed: roundsPlayed ?? this.roundsPlayed,
      correctAnswers: correctAnswers ?? this.correctAnswers,
    );
  }

  factory GameState.initial() {

    Map<int, List> quiz = _generateQuiz();

    return GameState._(
      board: quiz[0] as List<String>,
      playerHands: quiz[1] as List<PlayerHand>,
      result: "Please choose which hand wins.",
      roundsPlayed: 0,
      correctAnswers: 0,
    );
  }

  static Map<int, List> _generateQuiz() {

    List<String> newBoard = [];
    List<PlayerHand> newPlayerHands = [];

    newBoard.clear();
    newPlayerHands.clear();

    List<String> usedCards = [];
    for(int i = 0; i < 5; i++) {

      String card = _generateCard(usedCards);
      newBoard.add(card);
      usedCards.add(card);
    }

    for(int players = 0; players < 3; players++) {
      List<String> hand = [];
      for(int cards = 0; cards < 2; cards++) {
        String card = _generateCard(usedCards);

        hand.add(card);
        usedCards.add(card);
      }

      newPlayerHands.add(PlayerHand(cards: hand));
    }

    Map<int, List> map = {
      0: newBoard,
      1: newPlayerHands,
    };

    return map;
  }

  static String _generateCard(List<String> usedCards) {
    while(true) {
      String card = PokerHandDetector.FACES.elementAt(Random().nextInt(13)) + PokerHandDetector.SUITS.elementAt(Random().nextInt(4));
      if(!usedCards.contains(card)) {
        return card;
      }
    }
  }

  GameState sendAnswer(bool correct) {
    // based on the event, we compute the new state
    int newRoundsPlayed = roundsPlayed + 1;
    int newCorrectAnswers = correctAnswers;
    String newResult = "";

    if(correct) {
      newResult = "That was the best hand!";
      newCorrectAnswers++;
    } else {
      newResult = "That was not the best hand. :(";
    }

    Map<int, List> quiz = _generateQuiz();

    return copyWith(
      roundsPlayed: newRoundsPlayed,
      correctAnswers: newCorrectAnswers,
      result: newResult,
      board: quiz[0] as List<String>,
      playerHands: quiz[1] as List<PlayerHand>,
    );
  }

}
