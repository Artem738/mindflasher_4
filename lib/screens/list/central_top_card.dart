import 'package:flutter/material.dart';
import 'package:mindflasher_4/models/deck_model.dart';
import 'package:mindflasher_4/models/flashcard_model.dart';
import 'package:mindflasher_4/models/user_model.dart';
import 'package:mindflasher_4/providers/flashcard_provider.dart';
import 'package:mindflasher_4/providers/provider_user_control.dart';
import 'package:mindflasher_4/screens/list/swipeable_card.dart';
import 'package:mindflasher_4/tech_data/weight_delays_enum.dart';

import 'package:provider/provider.dart';

class CentralTopCard extends StatelessWidget {
  final FlashcardModel flashcard;
  final DeckModel deck;

  const CentralTopCard({
    Key? key,
    required this.flashcard,
    required this.deck,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String? token = context.read<UserModel>().token;
    final baseFontSize = context.watch<ProviderUserControl>().userModel.base_font_size;

    return Card(
      child: Stack(
        children: [
          // Основное содержимое карточки
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Колонка с кнопками
                GestureDetector(
                  onTap: () {}, // Пустой обработчик, чтобы кнопка была интерактивной
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 45,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () {
                            Provider.of<FlashcardProvider>(context, listen: false)
                                .updateCardWeight(deck, token!, flashcard.id, WeightDelaysEnum.goodLongDelay);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green, // Задаем цвет фона кнопки
                            padding: EdgeInsets.zero, // Убираем внутренние отступы
                          ),
                          child: Center(
                            child: Icon(Icons.more_time_rounded),
                          ),
                        ),
                      ),
                      SizedBox(height: 8.0),
                    ],
                  ),
                ),
                SizedBox(width: 8.0),
                // Текст
                Expanded(
                  child: Text(
                    flashcard.question,
                    style: TextStyle(fontSize: baseFontSize),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          // Невидимая зона для обработки нажатий
          Positioned.fill(
            left: 60, // Смещение области обработки нажатий вправо, чтобы не перекрывать зеленую кнопку
            child: GestureDetector(
              onTap: () {
                // Имитируем сворачивание карточки влево
                final swipeableCardState = context.findAncestorStateOfType<SwipeableCardState>();
                if (swipeableCardState != null) {
                  swipeableCardState.triggerLeftSwipeAndStartTimer();
                } else {
                  // print("SwipeableCardState не найден");
                }
              },
              child: Container(
                color: Colors.transparent, // Невидимая область
              ),
            ),
          ),
          // Лампочка в правом верхнем углу
          Positioned(
            top: 4.0,
            right: 4.0,
            child: Container(
              width: 9.0,
              height: 9.0,
              decoration: BoxDecoration(
                color: WeightDelaysEnum.getColor(flashcard.lastAnswerWeight), // Цвет лампочки
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
