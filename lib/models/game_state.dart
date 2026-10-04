import 'dare_card.dart';

class GamePlayer {
  String name;

  final List<DareCard> hand;

  DareCard? receivedDare;
  DareCard? lastSentDare;

  DateTime? lastSentDate;

  GamePlayer({
    required this.name,
    List<DareCard>? hand,
    this.receivedDare,
    this.lastSentDare,
    this.lastSentDate,
  }) : hand = hand ?? [];

  bool get canSendToday {
    if (lastSentDate == null) {
      return true;
    }

    final now = DateTime.now();
    final lastSent = lastSentDate!;

    return lastSent.year != now.year ||
        lastSent.month != now.month ||
        lastSent.day != now.day;
  }

  int get handCount => hand.length;
}

class GameState {
  final GamePlayer playerOne;
  final GamePlayer playerTwo;

  final List<DareCard> deck;

  GameState({
    required this.playerOne,
    required this.playerTwo,
    required this.deck,
  });

  GamePlayer playerFor(int playerIndex) {
    return playerIndex == 0
        ? playerOne
        : playerTwo;
  }

  GamePlayer partnerFor(int playerIndex) {
    return playerIndex == 0
        ? playerTwo
        : playerOne;
  }

  bool get gameComplete {
    return deck.isEmpty &&
        playerOne.hand.isEmpty &&
        playerTwo.hand.isEmpty &&
        playerOne.receivedDare == null &&
        playerTwo.receivedDare == null;
  }
}