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

    final userModel = context.watch<UserModel>();
    var txt = DeckIndexScreenTranslate(userModel.language_code ?? 'en');
    final deckProvider = context.watch<DeckProvider>();
    final baseFontSize = userModel.base_font_size;
    final userName = userModel.tg_first_name ?? userModel.name ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(txt.tt('title')),
        actions: [
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
                  padding: const EdgeInsets.all(28.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.collections_bookmark_outlined,
                        size: 96,
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        txt.tt('no_decks').replaceAll('{name}', userName),
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: (baseFontSize + 5).clamp(20.0, 26.0),
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        txt.tt('add_deck_prompt'),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                              fontSize: baseFontSize.clamp(14.0, 18.0),
                              height: 1.4,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      Card(
                        elevation: 0,
                        color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            txt.tt('description'),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontSize: (baseFontSize - 1).clamp(13.0, 17.0),
                                  height: 1.5,
                                ),
                            textAlign: TextAlign.left,
                          ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDeckBottomSheet(context, txt, baseFontSize),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDeckBottomSheet(BuildContext context, DeckIndexScreenTranslate txt, double baseFontSize) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Полоса-индикатор сверху шторки
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurfaceVariant.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Заголовок шторки
              Text(
                txt.tt('add_deck_title'),
                style: TextStyle(
                  fontSize: (baseFontSize + 3).clamp(16.0, 24.0),
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              
              // Вариант 1: Добавить готовый шаблон
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.secondaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.auto_awesome,
                    color: colorScheme.onSecondaryContainer,
                  ),
                ),
                title: Text(
                  txt.tt('add_template_deck'),
                  style: TextStyle(
                    fontSize: baseFontSize.clamp(14.0, 20.0),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context); // Закрываем шторку
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const TemplateDeckIndexScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              
              // Вариант 2: Создать свою колоду
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.add,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
                title: Text(
                  txt.tt('add_own_deck'),
                  style: TextStyle(
                    fontSize: baseFontSize.clamp(14.0, 20.0),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context); // Закрываем шторку
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const DeckManagementScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
