import 'package:flutter/material.dart';

import '../models/dare_card.dart';
import 'dare_card_widget.dart';

class PlayerHand extends StatelessWidget {
  final List<DareCard> cards;
  final int? selectedIndex;
  final ValueChanged<int> onCardSelected;

  const PlayerHand({
    super.key,
    required this.cards,
    required this.selectedIndex,
    required this.onCardSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        itemCount: cards.length,
        separatorBuilder: (_, _) =>
            const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return Center(
            child: DareCardWidget(
              card: cards[index],
              compact: true,
              selected: selectedIndex == index,
              onTap: () {
                onCardSelected(index);
              },
            ),
          );
        },
      ),
    );
  }
}
