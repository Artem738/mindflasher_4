import 'package:flutter/material.dart';
import 'package:mindflasher_4/models/user_model.dart';
import 'package:mindflasher_4/providers/provider_user_control.dart';
import 'package:mindflasher_4/providers/provider_user_login.dart';
import 'package:mindflasher_4/screens/deck/deck_management_screen.dart';
import 'package:mindflasher_4/screens/first_enter_screen.dart';
import 'package:mindflasher_4/screens/list/flashcard_index_screen.dart';
import 'package:mindflasher_4/screens/template_deck_index_screen.dart';
import 'package:mindflasher_4/screens/user_settings_screen.dart';

import 'package:provider/provider.dart';

import '../../providers/deck_provider.dart';
import '../../translates/deck_index_screen_translate.dart';
import 'deck_card.dart';

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
    _fetchDecksFuture = context.read<DeckProvider>().fetchDecks(context.read<UserModel>().token!);
  }

  @override
  Widget build(BuildContext context) {
    context.read<ProviderUserLogin>().expandTelegram();

   // final userModel = context.read<UserModel>();
    var txt = DeckIndexScreenTranslate(context.read<UserModel>().language_code ?? 'en');
    final deckProvider = context.watch<DeckProvider>();
    var baseFontSize = context.watch<ProviderUserControl>().userModel.base_font_size;
    final String? token = context.read<UserModel>().token;

    return Scaffold(
      appBar: AppBar(
        title: Text(txt.tt('title')),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              // Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(builder: (context) => FirstEnterScreen()),
              // );
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => FirstEnterScreen(),
                ),
              );
              // Navigator.of(context).pushAndRemoveUntil(
              //   MaterialPageRoute(builder: (context) => FirstEnterScreen()),
              //   (Route<dynamic> route) => false,
              // );
            },
          ),
          IconButton(
            icon: Icon(Icons.person_outline_outlined),
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
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 170),
                          Text(
                            txt.tt('no_decks'),
                            style: TextStyle(fontSize: (baseFontSize + 5).clamp(15.0 + 5, 20.0 + 5)),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            txt.tt('add_deck_prompt'),
                            style: TextStyle(
                              fontSize: (baseFontSize).clamp(15.0, 20.0),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 50),
                          Text(
                            txt.tt('description'),
                            style: TextStyle(
                              fontSize: (baseFontSize - 1).clamp(15.0, 20.0),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: deckProvider.decks.length,
                    itemBuilder: (ctx, i) {
                      return DeckCard(
                        deck: deckProvider.decks[i],
                        baseFontSize: context.watch<ProviderUserControl>().userModel.base_font_size,
                      );
                    },
                  );
          }
        },
      ),
      floatingActionButton: Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              //mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FloatingActionButton.extended(
                  heroTag: 'add_own_deck',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DeckManagementScreen(token: token!),
                      ),
                    );
                  },
                  label: Text(
                    txt.tt('add_own_deck'),
                    style: TextStyle(
                      fontSize: (baseFontSize).clamp(10.0, 25.0),
                    ),
                  ),
                  icon: const Icon(Icons.add_to_photos_outlined),
                ),
                SizedBox(height: 10),
                FloatingActionButton.extended(
                  heroTag: 'add_template_deck',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => TemplateDeckIndexScreen(),
                      ),
                    );
                  },
                  label: Text(
                    txt.tt('add_template_deck'),
                    style: TextStyle(
                      fontSize: (baseFontSize).clamp(10.0, 25.0),
                    ),
                  ),
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
