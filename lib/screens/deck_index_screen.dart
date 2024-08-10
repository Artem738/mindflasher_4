import 'package:flutter/material.dart';
import 'package:mindflasher_4/models/user_model.dart';
import 'package:mindflasher_4/screens/list/flashcard_index_screen.dart';
import 'package:mindflasher_4/screens/template_deck_index_screen.dart';
import 'package:mindflasher_4/screens/user_settings_screen.dart';

import 'package:provider/provider.dart';

import '../providers/deck_provider.dart';

class DeckIndexScreen extends StatelessWidget {
  const DeckIndexScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String? token = context.read<UserModel>().token;
    return Scaffold(
      appBar: AppBar(
        title: Text('Deck'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => UserSettingsScreen(),
                ),
              );

            },
          ),
        ],

      ),
      body: FutureBuilder(
        future: Provider.of<DeckProvider>(context, listen: false).fetchDecks(token!),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('An error occurred: ${snapshot.error}'));
          } else {
            return Consumer<DeckProvider>(
              builder: (ctx, deckProvider, child) => ListView.builder(
                itemCount: deckProvider.decks.length,
                itemBuilder: (ctx, i) => ListTile(
                  title: Text(deckProvider.decks[i].name),
                  subtitle: Text(deckProvider.decks[i].description),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => FlashcardIndexScreen(deck: deckProvider.decks[i]),
                      ),
                    );
                  },
                ),
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TemplateDeckIndexScreen(),
            ),
          );
        },
        label: Text('Add Deck'),
        icon: Icon(Icons.add),
      ),
    );
  }
}
