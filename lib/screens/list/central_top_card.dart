import 'package:flutter/material.dart';
import 'package:mindflasher_4/models/deck_model.dart';
import 'package:mindflasher_4/models/flashcard_model.dart';
import 'package:mindflasher_4/providers/flashcard_provider.dart';
import 'package:mindflasher_4/providers/provider_user_control.dart';
import 'package:mindflasher_4/services/app_haptics.dart';
import 'flashcard_study_screen.dart';
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

    final minCardHeight = baseFontSize * 3.6 + 16.0;

    return Card(
      elevation: 2,
      child: Container(
        constraints: BoxConstraints(minHeight: minCardHeight),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton.filled(
                      onPressed: () {
                        AppHaptics.lightImpact();
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
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            flashcard.question,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontSize: baseFontSize,
                                  fontWeight: FontWeight.w500,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          if (flashcard.nextReviewAt != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                () {
                                  final date = DateTime.parse(flashcard.nextReviewAt!).toLocal();
                                  return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
                                }(),
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                      color: colorScheme.onSurfaceVariant.withOpacity(0.7),
                                      fontSize: (baseFontSize - 4).clamp(10.0, 12.0),
                                    ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 40), // Space for the bulb and padding
                  ],
                ),
              ),
            ),
            Positioned.fill(
              left: 68,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => FlashcardStudyScreen(
                        flashcard: flashcard,
                        deck: deck,
                      ),
                    ),
                  );
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
      ),
    );
  }
}
