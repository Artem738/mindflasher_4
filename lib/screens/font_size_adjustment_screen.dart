import 'package:flutter/material.dart';
import 'package:mindflasher_4/screens/deck/deck_card.dart';
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
      DeckModel(name: 'Deck 1', description: 'Description 1', id: 1),
      DeckModel(name: 'Deck 2', description: 'Description 2', id: 2),
      DeckModel(name: 'Deck 3', description: 'Description 3', id: 3),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(txt.tt('title')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              txt.tt('header'),
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: decks.length,
                itemBuilder: (context, index) {
                  return DeckCard(deck: decks[index], baseFontSize: userModel.base_font_size);
                },
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    userControl.decreaseFontSize();
                  },
                  child: Text('—', style: TextStyle(fontSize: 25)),
                ),
                ElevatedButton(
                  onPressed: () {
                    userControl.increaseFontSize();
                  },
                  child: Text('+', style: TextStyle(fontSize: 25)),
                ),
              ],
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  userControl.updateUserBaseFontSize(userModel.token!, userModel.base_font_size);

                  Navigator.pop(context); // Возвращаемся на предыдущий экран
                },
                child: Text(txt.tt('finish_button'), style: TextStyle(fontSize: 20)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
