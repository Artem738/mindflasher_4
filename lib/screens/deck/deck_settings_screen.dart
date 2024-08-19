import 'package:flutter/material.dart';
import 'package:mindflasher_4/models/deck_model.dart';
import 'package:mindflasher_4/providers/deck_provider.dart';
import 'package:mindflasher_4/providers/flashcard_provider.dart';
import 'package:mindflasher_4/providers/provider_user_control.dart';
import 'package:mindflasher_4/screens/csv_management_screen.dart';
import 'package:mindflasher_4/screens/deck/deck_index_screen.dart';
import 'package:mindflasher_4/screens/deck/deck_management_screen.dart';
import 'package:mindflasher_4/screens/first_enter_screen.dart';
import 'package:mindflasher_4/screens/font_size_adjustment_screen.dart';
import 'package:mindflasher_4/screens/language_selection_screen.dart';
import 'package:mindflasher_4/screens/tap_code_screen.dart'; // Добавлен новый экран
import 'package:mindflasher_4/translates/deck_settings_screen_translate.dart';
import 'package:mindflasher_4/translates/font_size_adjustment_screen.dart';
import 'package:mindflasher_4/translates/user_settings_screen_translate.dart';
import 'package:provider/provider.dart';

class DeckSettingsScreen extends StatelessWidget {
  final DeckModel deck;

  DeckSettingsScreen({required this.deck});

  @override
  Widget build(BuildContext context) {
    final userControl = context.watch<ProviderUserControl>();
    final userModel = userControl.userModel;
    final baseFontSize = userModel.base_font_size;
    final token = userModel.token;
    var txt = DeckSettingsScreenTranslate (userModel.language_code ?? 'en');


    return Scaffold(
      appBar: AppBar(
        title: Text(txt.tt('deck_settings_title')),
        leading: ModalRoute.of(context)?.canPop == true
            ? null // Если есть роут возврата, оставляем стандартный AppBar
            : IconButton(
                // Если роута возврата нет, добавляем свою кнопку
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => DeckIndexScreen(),
                    ),
                  );
                },
              ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_outline),
            color: Colors.redAccent,
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Text(
                      txt.tt('delete_confirmation') ,
                      style: TextStyle(fontSize: 22),
                      textAlign: TextAlign.center,
                    ),
                    actions: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center, // Центрирование кнопок
                        children: <Widget>[
                          TextButton(
                            onPressed: () {
                              context.read<DeckProvider>().deleteDeck(deck.id, token!);
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) => DeckIndexScreen()),
                                (Route<dynamic> route) => false,
                              );
                            },
                            child: Text(
                              txt.tt('delete_button'),
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          SizedBox(width: 20), // Пробел между кнопками
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Закрываем диалог
                            },
                            child: Text(
                              txt.tt('cancel_button'),
                              style: TextStyle(fontSize: 21),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${txt.tt('deck')} - ${deck.name}',
                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: (baseFontSize + 5).clamp(10.0 + 5, 22.0 + 5)),
                ),
                const SizedBox(height: 15),
                Text(
                  deck.description,
                  style: TextStyle(fontSize: (baseFontSize).clamp(10.0, 22.0)),
                ),
                SizedBox(height: 20),
                Text(
                  '${txt.tt('deck_id')}: ${deck.id}',
                  style: TextStyle(fontSize: (baseFontSize).clamp(10.0, 22.0)),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DeckManagementScreen(
                          token: token!,
                          deck: deck,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    txt.tt('edit_deck'),
                    style: TextStyle(fontSize: (baseFontSize).clamp(10.0, 22.0)),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CsvManagementScreen(
                                token: token!,
                                deck: deck,
                              )),
                    );
                  },
                  child: Text(
                    txt.tt('csv_insert'),
                    style: TextStyle(fontSize: (baseFontSize).clamp(10.0, 22.0)),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Получаем CSV
                    final flashcards = context.read<FlashcardProvider>().flashcards;
                    final csvLines = flashcards.map((card) => '${card.question};${card.answer}').toList();
                    final csvString = csvLines.join('\n');
                    //print(csvString);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CsvManagementScreen(
                                token: token!,
                                deck: deck,
                                csvData: csvString,
                              )),
                    );
                  },
                  child: Text(
                    txt.tt('csv_get_data'),
                    style: TextStyle(fontSize: (baseFontSize).clamp(10.0, 22.0)),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DeckIndexScreen(),
                      ),
                      (Route<dynamic> route) => false,
                    );
                    // Navigator.pushReplacement(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => DeckIndexScreen()),
                    // );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen, // Задаем зелёный цвет фона кнопки
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16), // Добавляем отступы
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Скругляем углы кнопки
                    ),
                  ),
                  child: Center(
                    child: Text(
                      txt.tt('to_main'),
                      style: TextStyle(fontSize: (baseFontSize + 3).clamp(12.0 + 3, 22.0 + 3), color: Colors.black87),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
