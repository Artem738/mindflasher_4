import 'package:flutter/material.dart';
import 'package:mindflasher_4/models/template_deck_model.dart';
import 'package:mindflasher_4/providers/provider_user_control.dart';
import 'package:mindflasher_4/providers/template_flashcard_provider.dart';
import 'package:mindflasher_4/screens/template_deck_index_screen.dart';
import 'package:mindflasher_4/translates/template_flashcard_index_screen_translate.dart';
import 'package:provider/provider.dart';

class TemplateFlashcardIndexScreen extends StatelessWidget {
  final TemplateDeckModel deck;

  const TemplateFlashcardIndexScreen({Key? key, required this.deck}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final token = context.watch<ProviderUserControl>().userModel.token;
    final baseFontSize = context.read<ProviderUserControl>().userModel.base_font_size;
    var txt = TemplateFlashcardIndexScreenTranslate(context.read<ProviderUserControl>().userModel.language_code ?? 'en');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${deck.name} ${deck.deck_lang}',
          style: TextStyle(fontSize: (baseFontSize + 5).clamp(15.0 + 5, 20.0 + 5)),
        ),
      ),
      body: FutureBuilder(
        future: context.read<TemplateFlashcardProvider>().fetchFlashcards(deck.id, token!),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'An error occurred: ${snapshot.error}',
                style: TextStyle(fontSize: (baseFontSize).clamp(15.0, 20.0)),
              ),
            );
          } else {
            final flashcardProvider = context.read<TemplateFlashcardProvider>();
            return Padding(
              padding: const EdgeInsets.only(left: 25), // Здесь вы можете настроить паддинг
              child: ListView.builder(
                itemCount: flashcardProvider.templateFlashcards.length,
                itemBuilder: (ctx, i) {
                  return ListTile(
                    title: Text(
                      flashcardProvider.templateFlashcards[i].question,
                      style: TextStyle(fontSize: (baseFontSize + 2)),
                    ),
                    subtitle: Text(
                      flashcardProvider.templateFlashcards[i].answer,
                      style: TextStyle(fontSize: (baseFontSize)),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          bool success = await context.read<TemplateFlashcardProvider>().addTemplateBaseToUser(context, deck.id, token!);
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  txt.tt('template_base_added'),
                  style: TextStyle(fontSize: (baseFontSize).clamp(10.0, 25.0)),
                ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  txt.tt('failed_to_add'),
                  style: TextStyle(fontSize: (baseFontSize).clamp(10.0, 25.0)),
                ),
              ),
            );
          }
        },
        label: Text(
          txt.tt('make_your_own'),
          style: TextStyle(fontSize: (baseFontSize).clamp(10.0, 25.0)),
        ),
        icon: Icon(Icons.download_outlined),
      ),
    );
  }
}
