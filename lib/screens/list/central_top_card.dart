import 'package:flutter/material.dart';
import 'package:mindflasher_4/models/flashcard_model.dart';
import 'package:mindflasher_4/models/user_model.dart';
import 'package:mindflasher_4/providers/flashcard_provider.dart';
import 'package:mindflasher_4/providers/provider_user_control.dart';
import 'package:mindflasher_4/screens/list/swipeable_card.dart';
import 'package:mindflasher_4/tech_data/weight_delays_enum.dart';

import 'package:provider/provider.dart';

class CentralTopCard extends StatelessWidget {
  final FlashcardModel flashcard;

  const CentralTopCard({Key? key, required this.flashcard}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String? token = context.read<UserModel>().token;
    final baseFontSize = context.watch<ProviderUserControl>().userModel.base_font_size;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Колонка с кнопками
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      Provider.of<FlashcardProvider>(context, listen: false)
                          .updateCardWeight(token!, flashcard.id, WeightDelaysEnum.goodLongDelay);
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
            SizedBox(width: 8.0),
            // Текст
            Expanded(
              child: GestureDetector(
                onTap: () {
                  print("Card tapped: ${flashcard.question}"); // Вывод в консоль для проверки

                  // Имитируем сворачивание карточки влево
                  final swipeableCardState = context.findAncestorStateOfType<SwipeableCardState>();
                  if (swipeableCardState != null) {
                    swipeableCardState.triggerLeftSwipeAndStartTimer();
                  } else {
                    print("SwipeableCardState не найден");
                  }
                },
                child: Text(
                  flashcard.question,
                  style: TextStyle(fontSize: baseFontSize),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
