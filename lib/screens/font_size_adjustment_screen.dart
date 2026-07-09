import 'package:flutter/material.dart';
import 'package:mindflasher_4/screens/deck/deck_card.dart';
import 'package:mindflasher_4/screens/user_settings_screen.dart';
import 'package:mindflasher_4/translates/font_size_adjustment_screen.dart';
import 'package:provider/provider.dart';
import '../models/deck_model.dart';
import '../providers/provider_user_control.dart';

class FontSizeAdjustmentScreen extends StatelessWidget {
  const FontSizeAdjustmentScreen({super.key});

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
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: decks.length,
                itemBuilder: (context, index) {
                  return DeckCard(deck: decks[index], baseFontSize: userModel.base_font_size, isClickOnCardWork: false);
                },
              ),
            ),
            const SizedBox(height: 10),
            Text(
              ("${txt.tt('current_font_size')} ${context.watch<ProviderUserControl>().userModel.base_font_size}"),
              style: TextStyle(
                fontSize: (userModel.base_font_size + 5).clamp(14.0, 18.0),
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w300,
              ),
              //style: TextStyle(fontSize: userModel.base_font_size + 5),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    userControl.decreaseFontSize();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(12),
                  ),
                  child: const Icon(Icons.remove),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SegmentedButton<double>(
                    segments: [
                      ButtonSegment<double>(
                        value: 14.0,
                        label: Text(txt.tt('small'), style: const TextStyle(fontSize: 12)),
                      ),
                      ButtonSegment<double>(
                        value: 18.0,
                        label: Text(txt.tt('medium'), style: const TextStyle(fontSize: 14)),
                      ),
                      ButtonSegment<double>(
                        value: 24.0,
                        label: Text(txt.tt('large'), style: const TextStyle(fontSize: 16)),
                      ),
                    ],
                    selected: {
                      if (userModel.base_font_size <= 15) 14.0
                      else if (userModel.base_font_size <= 20) 18.0
                      else 24.0
                    },
                    onSelectionChanged: (Set<double> newSelection) {
                      userControl.updateUserBaseFontSize(newSelection.first);
                    },
                    showSelectedIcon: false,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    userControl.increaseFontSize();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(12),
                  ),
                  child: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UserSettingsScreen(),
                          ),
                        );
                      }
                    },
                    child: Text(
                      txt.tt('cancel_button'),
                      style: TextStyle(
                        fontSize: (userModel.base_font_size).clamp(15.0, 20.0),
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      userControl.updateUserBaseFontSize(userModel.base_font_size);
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UserSettingsScreen(),
                          ),
                        );
                      }
                    },
                    child: Text(
                      txt.tt('finish_button'),
                      style: TextStyle(
                        fontSize: (userModel.base_font_size + 5).clamp(15.0 + 5, 20.0 + 5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
