import 'package:flutter/material.dart';
import 'package:mindflasher_4/models/deck_model.dart';
import 'package:mindflasher_4/models/flashcard_model.dart';
import 'package:mindflasher_4/models/user_model.dart';
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
    final String? token = context.read<UserModel>().token;
    final baseFontSize = context.read<ProviderUserControl>().userModel.base_font_size;

    return Align(
      alignment: Alignment.centerRight,
      child: FractionallySizedBox(
        widthFactor: stopThreshold,
        child: Card(
          surfaceTintColor: Colors.orangeAccent.withOpacity(0.05),
          child: Stack(
            children: [
              // Основное содержимое карточки
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Левая колонка с кнопкой
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 45,
                          height: 45,
                          child: ElevatedButton(
                            onPressed: () {
                              Provider.of<FlashcardProvider>(context, listen: false)
                                  .updateCardWeight(deck, token!, flashcard.id, WeightDelaysEnum.badSmallDelay);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              padding: EdgeInsets.zero,
                            ),
                            child: Center(
                              child: Icon(Icons.timer_outlined, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Текст
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0), // Уменьшение отступа
                          child: Text(
                            flashcard.answer.replaceAll('\\n', '\n'),
                            style: TextStyle(color: Colors.black, fontSize: baseFontSize),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ),
                    ),
                    // Правая колонка с кнопкой
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () {
                              Provider.of<FlashcardProvider>(context, listen: false)
                                  .updateCardWeight(deck, token!, flashcard.id, WeightDelaysEnum.normMedDelay);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.yellow,
                              padding: EdgeInsets.zero,
                            ),
                            child: Center(
                              child: Icon(Icons.access_time_outlined),
                            ),
                          ),
                        ),
                        SizedBox(height: 8.0),
                      ],
                    ),
                  ],
                ),
              ),
              // Невидимая зона для обработки нажатий
              Positioned.fill(
                left: 55, // Смещение области обработки нажатий вправо, чтобы не перекрывать текст
                child: GestureDetector(
                  onTap: () {
                    Provider.of<FlashcardProvider>(context, listen: false)
                        .updateCardWeight(deck, token!, flashcard.id, WeightDelaysEnum.normMedDelay);
                  },
                  child: Container(
                    color: Colors.transparent, // Невидимая область
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
