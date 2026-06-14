import 'package:flutter/material.dart';
import 'package:mindflasher_4/models/user_model.dart';
import 'package:mindflasher_4/providers/provider_user_control.dart';
import 'package:mindflasher_4/providers/provider_user_login.dart';
import 'package:mindflasher_4/screens/deck/deck_management_screen.dart';
import 'package:mindflasher_4/screens/first_enter_screen.dart';
import 'package:mindflasher_4/screens/template_deck_index_screen.dart';
import 'package:mindflasher_4/screens/user_settings_screen.dart';

import 'package:provider/provider.dart';

import '../../providers/deck_provider.dart';
import '../../translates/deck_index_screen_translate.dart';
import 'deck_card.dart';

class DeckIndexScreen extends StatefulWidget {
  const DeckIndexScreen({super.key});

  @override
  _DeckIndexScreenState createState() => _DeckIndexScreenState();
}

class _DeckIndexScreenState extends State<DeckIndexScreen> {
  late final DeckIndexScreenTranslate txt;
  late Future<void> _fetchDecksFuture;

  @override
  void initState() {
    super.initState();
    _fetchDecksFuture = context.read<DeckProvider>().fetchDecks();
  }

  @override
  Widget build(BuildContext context) {
    context.read<ProviderUserLogin>().expandTelegram();

   // final userModel = context.read<UserModel>();
    var txt = DeckIndexScreenTranslate(context.read<UserModel>().language_code ?? 'en');
    final deckProvider = context.watch<DeckProvider>();
    var baseFontSize = context.watch<ProviderUserControl>().userModel.base_font_size;
    return Scaffold(
      appBar: AppBar(
        title: Text(txt.tt('title')),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              // Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(builder: (context) => FirstEnterScreen()),
              // );
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const FirstEnterScreen(),
                ),
              );
              // Navigator.of(context).pushAndRemoveUntil(
              //   MaterialPageRoute(builder: (context) => FirstEnterScreen()),
              //   (Route<dynamic> route) => false,
              // );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_outline_outlined),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const UserSettingsScreen(),
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
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading decks.'));
          } else {
            if (deckProvider.decks.isEmpty) {
              return Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.collections_bookmark_outlined,
                        size: 80,
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        txt.tt('no_decks'),
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: (baseFontSize + 5).clamp(20.0, 25.0),
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        txt.tt('add_deck_prompt'),
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                              fontSize: (baseFontSize).clamp(16.0, 20.0),
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          txt.tt('description'),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontStyle: FontStyle.italic,
                                fontSize: (baseFontSize - 1).clamp(14.0, 18.0),
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 80),
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
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: 'add_template_deck',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const TemplateDeckIndexScreen(),
                ),
              );
            },
            label: Text(
              txt.tt('add_template_deck'),
              style: TextStyle(
                fontSize: (baseFontSize).clamp(12.0, 18.0),
              ),
            ),
            icon: const Icon(Icons.auto_awesome),
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
          ),
          const SizedBox(height: 12),
          FloatingActionButton.extended(
            heroTag: 'add_own_deck',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const DeckManagementScreen(),
                ),
              );
            },
            label: Text(
              txt.tt('add_own_deck'),
              style: TextStyle(
                fontSize: (baseFontSize).clamp(12.0, 18.0),
              ),
            ),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
