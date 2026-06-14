import 'package:flutter/material.dart';
import 'package:mindflasher_4/models/deck_model.dart';
import 'package:mindflasher_4/models/flashcard_model.dart';
import 'package:mindflasher_4/providers/flashcard_provider.dart';
import 'package:mindflasher_4/providers/provider_user_control.dart';
import 'package:mindflasher_4/tech_data/weight_delays_enum.dart';

import 'package:provider/provider.dart';

class RightAnswerCard extends StatelessWidget {
  final DeckModel deck;
  final FlashcardModel flashcard;
  final double stopThreshold;

  const RightAnswerCard({
    Key? key,
    required this.deck,
    required this.flashcard,
    required this.stopThreshold,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final baseFontSize =
        context.read<ProviderUserControl>().userModel.base_font_size;
    final colorScheme = Theme.of(context).colorScheme;

    return Align(
      alignment: Alignment.centerRight,
      child: FractionallySizedBox(
        widthFactor: stopThreshold,
        child: Card(
          color: colorScheme.secondaryContainer.withOpacity(0.9),
          child: Stack(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton.filled(
                      onPressed: () {
                        Provider.of<FlashcardProvider>(context, listen: false)
                            .updateCardWeight(deck, flashcard.id,
                                WeightDelaysEnum.badSmallDelay);
                      },
                      icon: const Icon(Icons.history),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          flashcard.answer.replaceAll('\\n', '\n'),
                          style: TextStyle(
                            color: colorScheme.onSecondaryContainer,
                            fontSize: baseFontSize,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                    IconButton.filled(
                      onPressed: () {
                        Provider.of<FlashcardProvider>(context, listen: false)
                            .updateCardWeight(deck, flashcard.id,
                                WeightDelaysEnum.normMedDelay);
                      },
                      icon: const Icon(Icons.schedule),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black87,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned.fill(
                left: 64,
                right: 64,
                child: GestureDetector(
                  onTap: () {
                    Provider.of<FlashcardProvider>(context, listen: false)
                        .updateCardWeight(
                            deck, flashcard.id, WeightDelaysEnum.normMedDelay);
                  },
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
