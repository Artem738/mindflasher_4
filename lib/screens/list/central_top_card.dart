import 'package:flutter/material.dart';
import 'package:mindflasher_4/models/deck_model.dart';
import 'package:mindflasher_4/models/flashcard_model.dart';
import 'package:mindflasher_4/providers/flashcard_provider.dart';
import 'package:mindflasher_4/providers/provider_user_control.dart';
import 'package:mindflasher_4/screens/list/swipeable_card.dart';
import 'package:mindflasher_4/tech_data/weight_delays_enum.dart';

import 'package:provider/provider.dart';

class CentralTopCard extends StatelessWidget {
  final FlashcardModel flashcard;
  final DeckModel deck;

  const CentralTopCard({
    super.key,
    required this.flashcard,
    required this.deck,
  });

  @override
  Widget build(BuildContext context) {
    final baseFontSize =
        context.watch<ProviderUserControl>().userModel.base_font_size;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 2,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton.filled(
                  onPressed: () {
                    Provider.of<FlashcardProvider>(context, listen: false)
                        .updateCardWeight(
                            deck, flashcard.id, WeightDelaysEnum.goodLongDelay);
                  },
                  icon: const Icon(Icons.check_circle_outline),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Text(
                    flashcard.question,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: baseFontSize,
                          fontWeight: FontWeight.w500,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 40), // Space for the bulb and padding
              ],
            ),
          ),
          Positioned.fill(
            left: 68,
            child: GestureDetector(
              onTap: () {
                final swipeableCardState =
                    context.findAncestorStateOfType<SwipeableCardState>();
                if (swipeableCardState != null) {
                  swipeableCardState.triggerLeftSwipeAndStartTimer();
                }
              },
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          Positioned(
            top: 8.0,
            right: 8.0,
            child: Container(
              width: 12.0,
              height: 12.0,
              decoration: BoxDecoration(
                color: WeightDelaysEnum.getColor(flashcard.lastAnswerWeight),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: WeightDelaysEnum.getColor(flashcard.lastAnswerWeight)
                        .withOpacity(0.4),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
