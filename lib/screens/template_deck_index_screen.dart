import 'package:flutter/material.dart';
import 'package:mindflasher_4/providers/template_deck_provider.dart';
import 'package:mindflasher_4/providers/provider_user_control.dart';
import 'package:mindflasher_4/providers/template_flashcard_provider.dart';
import 'package:mindflasher_4/screens/template_flashcard_index_screen.dart';
import 'package:provider/provider.dart';

class TemplateDeckIndexScreen extends StatelessWidget {
  const TemplateDeckIndexScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final token = context.watch<ProviderUserControl>().userModel.token;

    return Scaffold(
      appBar: AppBar(
        title: Text('Template Decks'),
      ),
      body: FutureBuilder(
        future: context.read<TemplateDeckProvider>().fetchDecks(token!),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('An error occurred: ${snapshot.error}'));
          } else {
            return Consumer<TemplateDeckProvider>(
              builder: (ctx, deckProvider, child) => ListView.builder(
                itemCount: deckProvider.decks.length,
                itemBuilder: (ctx, i) => ListTile(
                  minLeadingWidth: 0,
                  title: Text(deckProvider.decks[i].name),
                  subtitle: Text(deckProvider.decks[i].description),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => TemplateFlashcardIndexScreen(deck: deckProvider.decks[i]),
                      ),
                    );
                  },
                  trailing: ElevatedButton.icon(
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
                            content: Text('Failed to add template base'),
                          ),
                        );
                      }
                    },
                    icon: Icon(Icons.add),
                    label: Text('Add'),
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
