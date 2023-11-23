import 'dart:math';

import 'package:poker_hand_test/flutter_flux/flutter_flux.dart';
import 'package:poker_hand_test/player_hand.dart';

import 'hand_detector.dart';

final GameStoreActions gameStoreActions = GameStoreActions();
final GameStore gameStore = GameStore(gameStoreActions);
final StoreToken gameStoreToken = StoreToken(gameStore);

class GameStoreActions {
  final generateHand = Action<void>();
  final captureUserSelection = Action<int>();
}

class GameStore extends Store{

  final GameStoreActions _gameStoreActions;

  List<String> board = [];
  List<PlayerHand> playerHands = [];
  String result = "Please choose which hand wins.";
  int roundsPlayed = 0;
  int correctAnswers = 0;

  GameStore(this._gameStoreActions) {
    _gameStoreActions.generateHand.listen(_generateHand);
    _gameStoreActions.captureUserSelection.listen(_captureUserSelection);
  }

  void _generateHand(_) {
    board.clear();
    playerHands.clear();

    List<String> usedCards = [];
    for(int i = 0; i < 5; i++) {

      String card = _generateCard(usedCards);
      board.add(card);
      usedCards.add(card);
    }

    for(int players = 0; players < 3; players++) {
      List<String> hand = [];
      for(int cards = 0; cards < 2; cards++) {
        String card = _generateCard(usedCards);

        hand.add(card);
        usedCards.add(card);
      }

      playerHands.add(PlayerHand(cards: hand));
    }

    trigger();
  }

  void _captureUserSelection(int? handNumber) {
    PlayerHand playerHand = playerHands[handNumber!];
    List<String> fullHand = List.from(board);
    fullHand.addAll(playerHand.cards);

    PokerHand pokerHand = PokerHandDetector.detectHand(fullHand);

    bool isBestHand = true;
    for (PlayerHand h in playerHands) {
      if (h.cards != playerHand.cards) {
        var hand1 = PokerHandDetector.bestHandNoLimits(board, playerHand.cards);
        var hand2 = PokerHandDetector.bestHandNoLimits(board, h.cards);

        int i = hand1!.compareTo(hand2);
        if (i < 0) {
          isBestHand = false;
          break;
        }
      }
    }

    if (isBestHand) {
      result = "That was the best hand! ${pokerHand.type.name}";
      correctAnswers++;
    } else {
      result = "That was not the best hand. :(";
    }

    gameStore.roundsPlayed++;

    trigger();
  }

  String _generateCard(List<String> usedCards) {
    while(true) {
      String card = PokerHandDetector.FACES.elementAt(Random().nextInt(13)) + PokerHandDetector.SUITS.elementAt(Random().nextInt(4));
      if(!usedCards.contains(card)) {
        return card;
      }
    }
  }
}