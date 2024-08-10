import 'package:flutter/material.dart';
import 'package:mindflasher_4/models/template_deck_model.dart';
import 'package:mindflasher_4/providers/provider_user_control.dart';
import 'package:mindflasher_4/providers/template_flashcard_provider.dart';
import 'package:mindflasher_4/screens/template_deck_index_screen.dart';
import 'package:provider/provider.dart';

class TemplateFlashcardIndexScreen extends StatelessWidget {
  final TemplateDeckModel deck;

  const TemplateFlashcardIndexScreen({Key? key, required this.deck}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final token = context.watch<ProviderUserControl>().userModel.token;

    return Scaffold(
      appBar: AppBar(
        title: Text('${deck.name}'),
      ),
      body: FutureBuilder(
        future: context.read<TemplateFlashcardProvider>().fetchFlashcards(deck.id, token!),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('An error occurred: ${snapshot.error}'));
          } else {
            final flashcardProvider = context.read<TemplateFlashcardProvider>();
            return Padding(
              padding: const EdgeInsets.only(left: 25), // Здесь вы можете настроить паддинг
              child: ListView.builder(
                itemCount: flashcardProvider.flashcards.length,
                itemBuilder: (ctx, i) {
                  return ListTile(
                    title: Text(flashcardProvider.flashcards[i].question),
                    subtitle: Text(flashcardProvider.flashcards[i].answer),
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
                content: Text('Template base successfully added to your Decks'),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to add template base'),
              ),
            );
          }
        },
        label: Text('Make Your Own'),
        icon: Icon(Icons.download_outlined),
      ),
    );
  }
}
