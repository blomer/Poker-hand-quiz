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
    return GameState._(
      board: [],
      playerHands: [],
      result: "Please choose which hand wins.",
      roundsPlayed: 0,
      correctAnswers: 0,
    );
  }

  GameState apply(GameEvent event) {
    // based on the event, we compute the new state
    int newRoundsPlayed = roundsPlayed + 1;
    return copyWith(
      roundsPlayed: newRoundsPlayed,
    );
  }

}
