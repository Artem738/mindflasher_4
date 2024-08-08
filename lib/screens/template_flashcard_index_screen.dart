import 'package:flutter/material.dart';
import 'package:mindflasher_4/models/template_deck_model.dart';
import 'package:mindflasher_4/providers/provider_user_control.dart';
import 'package:mindflasher_4/providers/template_flashcard_provider.dart';
import 'package:provider/provider.dart';

class TemplateFlashcardIndexScreen extends StatelessWidget {
  final TemplateDeckModel deck;

  const TemplateFlashcardIndexScreen({Key? key, required this.deck}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final token = context.watch<ProviderUserControl>().userModel.token;

    return Scaffold(
      appBar: AppBar(
        title: Text('Flashcards for ${deck.name}'),
      ),
      body: FutureBuilder(
        future: context.read<TemplateFlashcardProvider>().fetchFlashcards(deck.id, token!),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('An error occurred: ${snapshot.error}'));
          } else {
            return Consumer<TemplateFlashcardProvider>(
              builder: (ctx, flashcardProvider, child) => ListView.builder(
                itemCount: flashcardProvider.flashcards.length,
                itemBuilder: (ctx, i) => ListTile(
                  title: Text(flashcardProvider.flashcards[i].question),
                  subtitle: Text(flashcardProvider.flashcards[i].answer),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
