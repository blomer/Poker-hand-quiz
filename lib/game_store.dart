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

  GameState gameState = GameState.initial();

  GameStore(this._gameStoreActions) {
    _gameStoreActions.generateHand.listen(_generateHand);
    _gameStoreActions.captureUserSelection.listen(_captureUserSelection);
  }

  void _generateHand(_) {
    gameState = gameState.apply(Event());

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
