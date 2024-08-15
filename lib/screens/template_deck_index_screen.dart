import 'package:flutter/material.dart';
import 'package:mindflasher_4/providers/template_deck_provider.dart';
import 'package:mindflasher_4/providers/provider_user_control.dart';
import 'package:mindflasher_4/providers/template_flashcard_provider.dart';
import 'package:mindflasher_4/screens/template_flashcard_index_screen.dart';
import 'package:mindflasher_4/translates/template_deck_index_screen_translate.dart';
import 'package:provider/provider.dart';

class TemplateDeckIndexScreen extends StatelessWidget {
  const TemplateDeckIndexScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final token = context.watch<ProviderUserControl>().userModel.token;

    final baseFontSize = context.read<ProviderUserControl>().userModel.base_font_size;
    var txt = TemplateDeckIndexScreenTranslate(context.read<ProviderUserControl>().userModel.language_code ?? 'en');

    return Scaffold(
      appBar: AppBar(
        title: Text(txt.tt('template_decks')),
      ),
      body: FutureBuilder(
        future: context.read<TemplateDeckProvider>().fetchDecks(token!),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("${txt.tt('error_occurred')}: ${snapshot.error}"));
          } else {
            return Consumer<TemplateDeckProvider>(
              builder: (ctx, deckProvider, child) => ListView.builder(
                itemCount: deckProvider.decks.length,
                itemBuilder: (ctx, i) => ListTile(
                  minLeadingWidth: 0,
                  title: Text(
                    deckProvider.decks[i].name,
                    style: TextStyle(fontSize: (baseFontSize + 5)), //.clamp(10.0 + 5, 20.0 + 5))
                  ),
                  subtitle: Text(
                    deckProvider.decks[i].description,
                    style: TextStyle(fontSize: (baseFontSize)), // .clamp(15.0, 20.0))
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => TemplateFlashcardIndexScreen(deck: deckProvider.decks[i]),
                      ),
                    );
                  },
                  trailing: SizedBox(
                    width: 50, // Устанавливаем фиксированную ширину для кнопки
                    height: 50, // Устанавливаем фиксированную высоту для кнопки
                    child: ElevatedButton(
                      onPressed: () async {
                        bool success = await context.read<TemplateFlashcardProvider>().addTemplateBaseToUser(
                              context,
                              deckProvider.decks[i].id,
                              token!,
                            );
                        if (success) {
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(txt.tt('failed_to_add')),
                            ),
                          );
                        }
                      },
                      child: Center(
                        child: Text(
                          '+',
                          style: TextStyle(
                            fontSize: 30, // Размер шрифта
                            height: 0.1, // Настройка высоты строки для выравнивания по центру
                          ),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(), // Делаем кнопку круглой
                        padding: EdgeInsets.all(8), // Настраиваем отступы для круглой формы
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
