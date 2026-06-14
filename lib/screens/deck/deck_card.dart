import 'package:flutter/material.dart';
import 'package:mindflasher_4/models/deck_model.dart';
import 'package:mindflasher_4/screens/list/flashcard_index_screen.dart';

class DeckCard extends StatelessWidget {
  final DeckModel deck;
  final double baseFontSize;
  final bool isClickOnCardWork;

  const DeckCard({
    Key? key,
    required this.deck,
    required this.baseFontSize,
    this.isClickOnCardWork = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: isClickOnCardWork
            ? () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => FlashcardIndexScreen(deck: deck),
                  ),
                );
              }
            : null,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Icon(
                  Icons.folder_open_outlined,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      deck.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: baseFontSize + 2,
                          ),
                    ),
                    if (deck.description.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        deck.description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                              fontSize: baseFontSize,
                            ),
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
