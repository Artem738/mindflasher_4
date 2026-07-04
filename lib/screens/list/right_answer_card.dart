import 'package:flutter/material.dart';
import 'package:mindflasher_4/models/deck_model.dart';
import 'package:mindflasher_4/models/flashcard_model.dart';
import 'package:mindflasher_4/providers/flashcard_provider.dart';
import 'package:mindflasher_4/providers/provider_user_control.dart';
import 'package:mindflasher_4/tech_data/weight_delays_enum.dart';
import 'package:mindflasher_4/translates/flashcard_study_screen_translate.dart';
import 'package:flutter/services.dart';
import 'flashcard_study_screen.dart';

import 'package:provider/provider.dart';

String _stripMarkdown(String markdown) {
  String txt = markdown.replaceAll('\n', ' ');
  txt = txt.replaceAll(RegExp(r'^#+\s+', multiLine: true), '');
  txt = txt.replaceAll(RegExp(r'\*\*|__|\*|_'), '');
  txt = txt.replaceAll(RegExp(r'```[a-zA-Z]*\n?'), '');
  txt = txt.replaceAll('`', '');
  txt = txt.replaceAll(RegExp(r'\s+'), ' ');
  return txt.trim();
}

class RightAnswerCard extends StatelessWidget {
  final DeckModel deck;
  final FlashcardModel flashcard;
  final double stopThreshold;

  const RightAnswerCard({
    super.key,
    required this.deck,
    required this.flashcard,
    this.stopThreshold = 0.9,
  });

  @override
  Widget build(BuildContext context) {
    final baseFontSize =
        context.read<ProviderUserControl>().userModel.base_font_size;
    final userLanguage =
        context.read<ProviderUserControl>().userModel.language_code ?? 'en';
    final colorScheme = Theme.of(context).colorScheme;

    final answerText = flashcard.answer.replaceAll('\\n', '\n');
    final isLong = answerText.length > 120 || '\n'.allMatches(answerText).length > 2;
    final strippedText = _stripMarkdown(answerText);
    final previewText = isLong 
        ? (strippedText.endsWith('...') || strippedText.endsWith('…') 
            ? strippedText 
            : '$strippedText ...') 
        : strippedText;

    void handleMiddleTap() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => FlashcardStudyScreen(
            flashcard: flashcard,
            deck: deck,
            startAnswerRevealed: true,
          ),
        ),
      );
    }

    return Card(
      color: colorScheme.secondaryContainer.withOpacity(0.9),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton.filled(
                    onPressed: () {
                      HapticFeedback.lightImpact();
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
                        previewText,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: colorScheme.onSecondaryContainer,
                          fontSize: baseFontSize * 0.9,
                          height: 1.3,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                  IconButton.filled(
                    onPressed: () {
                      HapticFeedback.lightImpact();
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
          ),
          Positioned.fill(
            left: 64,
            right: 64,
            child: GestureDetector(
              onTap: handleMiddleTap,
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
