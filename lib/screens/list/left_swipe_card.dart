import 'package:flutter/material.dart';
import 'package:mindflasher_4/models/deck_model.dart';
import 'package:mindflasher_4/models/flashcard_model.dart';
import 'package:mindflasher_4/screens/flashcard_management_screen.dart';


class LeftSwipeCard extends StatelessWidget {
  final DeckModel deck;
  final FlashcardModel flashcard;
  final double stopThreshold;

  const LeftSwipeCard({
    super.key,
    required this.deck,
    required this.flashcard,
    this.stopThreshold = 0.4,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton.filled(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => FlashcardManagementScreen(
                      deck: deck,
                      flashcard: flashcard,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.edit_outlined),
              style: IconButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "ID: ${flashcard.id}",
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                Text(
                  "W: ${flashcard.weight}",
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
