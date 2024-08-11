import 'package:flutter/material.dart';
import 'package:mindflasher_4/models/user_model.dart';
import 'package:mindflasher_4/screens/list/flashcard_index_screen.dart';
import 'package:mindflasher_4/screens/template_deck_index_screen.dart';
import 'package:mindflasher_4/screens/user_settings_screen.dart';

import 'package:provider/provider.dart';

import '../providers/deck_provider.dart';
import '../translates/deck_index_screen_translate.dart';

class DeckIndexScreen extends StatefulWidget {
  const DeckIndexScreen({Key? key}) : super(key: key);

  @override
  _DeckIndexScreenState createState() => _DeckIndexScreenState();
}

class _DeckIndexScreenState extends State<DeckIndexScreen> {
  late final DeckIndexScreenTranslate txt;
  late Future<void> _fetchDecksFuture;

  @override
  void initState() {
    super.initState();
    txt = DeckIndexScreenTranslate(context.read<UserModel>().languageCode ?? 'en');
    _fetchDecksFuture = context.read<DeckProvider>().fetchDecks(context.read<UserModel>().token!);
  }

  @override
  Widget build(BuildContext context) {
    final deckProvider = context.watch<DeckProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(txt.tt('title')),
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
        future: _fetchDecksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading decks.'));
          } else {
            return deckProvider.decks.isEmpty
                ? Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 150),
                  Text(
                    txt.tt('no_decks'),
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  Text(txt.tt('add_deck_prompt')),
                ],
              ),
            )
                : ListView.builder(
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
        label: Text(txt.tt('add_deck')),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
