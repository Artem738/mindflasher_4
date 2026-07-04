import 'package:flutter/material.dart';
import 'package:mindflasher_4/models/deck_model.dart';
import 'package:mindflasher_4/providers/flashcard_provider.dart';
import 'package:mindflasher_4/providers/provider_user_control.dart';
// Добавлен новый экран
import 'package:mindflasher_4/translates/deck_settings_screen_translate.dart';
import 'package:provider/provider.dart';

class ImportTableScreen extends StatelessWidget {
  final DeckModel deck;

  const ImportTableScreen({super.key, required this.deck});

  @override
  Widget build(BuildContext context) {
    final userControl = context.watch<ProviderUserControl>();
    final userModel = userControl.userModel;
    final baseFontSize = userModel.base_font_size;
    var txt = DeckSettingsScreenTranslate(userModel.language_code ?? 'en');

    return Scaffold(
      appBar: AppBar(
        title: Text(txt.tt('deck_import_title')),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${txt.tt('import_in')} - ${deck.name}',
                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: (baseFontSize + 5).clamp(10.0 + 5, 22.0 + 5)),
                ),
                const SizedBox(height: 15),
                Text(
                  deck.description,
                  style: TextStyle(fontSize: (baseFontSize).clamp(10.0, 22.0)),
                ),
                const SizedBox(height: 20),
                Text(
                  '${txt.tt('deck_id')}: ${deck.id}',
                  style: TextStyle(fontSize: (baseFontSize).clamp(10.0, 22.0)),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      bool success = await context.read<FlashcardProvider>().importTable(deck.id, 3, 4);

                      // Показываем соответствующий SnackBar в зависимости от результата
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            success ? txt.tt('import_success') : txt.tt('import_failed'),
                            style: const TextStyle(fontSize: 16),
                          ),
                          backgroundColor: success ? Colors.green : Colors.red,
                        ),
                      );
                    },

                    child: Text(
                      txt.tt('import_table'),
                      style: TextStyle(fontSize: (baseFontSize).clamp(10.0, 22.0)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
