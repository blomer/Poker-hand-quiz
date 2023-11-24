
import 'dart:math';

import 'package:poker_hand_test/flutter_flux/flutter_flux.dart';
import 'package:poker_hand_test/player_hand.dart';

import 'game_state.dart';
import 'hand_detector.dart';

final GameStoreActions gameStoreActions = GameStoreActions();
final GameStore gameStore = GameStore(gameStoreActions);
final StoreToken gameStoreToken = StoreToken(gameStore);

class GameStoreActions {
  final captureUserSelection = Action<int>();
}

class GameStore extends Store{

  final GameStoreActions _gameStoreActions;

  GameState gameState = GameState.initial();

  GameStore(this._gameStoreActions) {
    _gameStoreActions.captureUserSelection.listen(_captureUserSelection);
  }

  void _captureUserSelection(int? handNumber) {
    PlayerHand playerHand = gameState.playerHands[handNumber!];
    List<String> fullHand = List.from(gameState.board);
    fullHand.addAll(playerHand.cards);

    PokerHand pokerHand = PokerHandDetector.detectHand(fullHand);

    bool isBestHand = true;
    for (PlayerHand h in gameState.playerHands) {
      if (h.cards != playerHand.cards) {
        var hand1 = PokerHandDetector.bestHandNoLimits(gameState.board, playerHand.cards);
        var hand2 = PokerHandDetector.bestHandNoLimits(gameState.board, h.cards);

        int i = hand1!.compareTo(hand2);
        if (i < 0) {
          isBestHand = false;
          break;
        }
      }
    }

    String result;

    if (isBestHand) {
      result = "That was the best hand! ${pokerHand.type.name}";
    } else {
      result = "That was not the best hand. :(";
    }

    gameState = gameState.sendAnswer(isBestHand);

    trigger();
  }
}
