import 'package:flutter/material.dart';
import 'package:mindflasher_4/screens/deck/deck_card.dart';
import 'package:mindflasher_4/screens/first_enter_screen.dart';
import 'package:mindflasher_4/screens/user_settings_screen.dart';
import 'package:mindflasher_4/translates/font_size_adjustment_screen.dart';
import 'package:provider/provider.dart';
import '../models/deck_model.dart';
import '../providers/provider_user_control.dart';

class FontSizeAdjustmentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userControl = context.watch<ProviderUserControl>();
    final userModel = userControl.userModel;
    var txt = FontSizeAdjustmentScreenTranslate(userModel.language_code ?? 'en');

    // Пример данных для ListView (замените на реальные данные, если нужно)
    final List<DeckModel> decks = [
      DeckModel(name: txt.tt('question_star'), description: txt.tt('short_answer_example'), id: 1),
      DeckModel(name: txt.tt('medium_question'), description: txt.tt('hidden_answer'), id: 2),
      DeckModel(name: txt.tt('font_size_prompt'), description: txt.tt('swipe_to_reveal_answer'), id: 3),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          txt.tt('title'),
          textAlign: TextAlign.center,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              txt.tt('font_example'),
              style: TextStyle(fontSize: (userModel.base_font_size + 3).clamp(18.0, 28.0)),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: decks.length,
                itemBuilder: (context, index) {
                  return DeckCard(deck: decks[index], baseFontSize: userModel.base_font_size, isClickOnCardWork: false);
                },
              ),
            ),
            SizedBox(height: 10),
            Text(
              txt.tt('current_font_size ${context.watch<ProviderUserControl>().userModel.base_font_size}'),
              style: TextStyle(
                fontSize: (userModel.base_font_size + 5).clamp(14.0, 18.0),
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w300,
              ),
              //style: TextStyle(fontSize: userModel.base_font_size + 5),
              textAlign: TextAlign.center,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    userControl.decreaseFontSize();
                  },
                  child: Text('—', style: TextStyle(fontSize: 30)),
                ),
                ElevatedButton(
                  onPressed: () {
                    userControl.decreaseFontSizeByTenth(); // Уменьшение на 0.1
                  },
                  child: Text('—0.1', style: TextStyle(fontSize: 20)),
                ),
                ElevatedButton(
                  onPressed: () {
                    userControl.increaseFontSizeByTenth(); // Увеличение на 0.1
                  },
                  child: Text('+0.1', style: TextStyle(fontSize: 20)),
                ),
                ElevatedButton(
                  onPressed: () {
                    userControl.increaseFontSize();
                  },
                  child: Text('+', style: TextStyle(fontSize: 30)),
                ),
              ],
            ),
            SizedBox(height: 16),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Распределяем кнопки равномерно по горизонтали
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserSettingsScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Отменить',
                      style: TextStyle(
                        fontSize: (userModel.base_font_size).clamp(15.0, 20.0),
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                  if (userModel.isFirstEnter != true) ...[
                    ElevatedButton(
                      onPressed: () {
                        userControl.updateUserBaseFontSize(userModel.token!, userModel.base_font_size);

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserSettingsScreen(),
                          ),
                        ); // Возвращаемся на предыдущий экран с сохранением
                      },
                      child: Text(
                        txt.tt('finish_button'),
                        style: TextStyle(
                          fontSize: (userModel.base_font_size + 5).clamp(15.0 + 5, 20.0 + 5),
                        ),
                      ),
                    ),
                  ] else ...[
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FirstEnterScreen(),
                          ),
                        ); // Переход на другой экран
                      },
                      child: Text(
                        txt.tt('continue'),
                        style: TextStyle(
                          fontSize: (userModel.base_font_size + 5).clamp(15.0 + 5, 20.0 + 5),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
