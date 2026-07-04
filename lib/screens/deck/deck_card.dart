import 'package:flutter/material.dart';
import 'package:mindflasher_4/models/deck_model.dart';
import 'package:mindflasher_4/screens/list/flashcard_index_screen.dart';
import 'package:mindflasher_4/screens/deck/deck_progress_chart.dart';
import 'package:provider/provider.dart';
import 'package:mindflasher_4/providers/deck_provider.dart';

class DeckCard extends StatelessWidget {
  final DeckModel deck;
  final double baseFontSize;
  final bool isClickOnCardWork;

  const DeckCard({
    super.key,
    required this.deck,
    required this.baseFontSize,
    this.isClickOnCardWork = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: isClickOnCardWork
            ? () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => FlashcardIndexScreen(deck: deck),
                  ),
                );
                if (context.mounted) {
                  context.read<DeckProvider>().fetchDecks();
                }
              }
            : null,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              DeckProgressChart(
                totalCards: deck.totalCards,
                grayCards: deck.grayCards,
                redCards: deck.redCards,
                yellowCards: deck.yellowCards,
                greenCards: deck.greenCards,
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
