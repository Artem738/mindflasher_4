import 'package:flutter/material.dart';
import 'package:mindflasher_4/models/deck_model.dart';
import 'package:mindflasher_4/models/flashcard_model.dart';
import 'package:mindflasher_4/models/user_model.dart';
import 'package:mindflasher_4/providers/deck_provider.dart';
import 'package:mindflasher_4/providers/flashcard_provider.dart';
import 'package:mindflasher_4/providers/provider_user_login.dart';
import 'package:mindflasher_4/screens/deck/deck_index_screen.dart';
import 'package:mindflasher_4/screens/deck/deck_settings_screen.dart';
import 'package:mindflasher_4/screens/flashcard_management_screen.dart';
import 'package:mindflasher_4/translates/flashcard_index_screen_translate.dart';
import 'package:provider/provider.dart';
import 'swipeable_card.dart';

class FlashcardIndexScreen extends StatefulWidget {
  final DeckModel deck;

  FlashcardIndexScreen({super.key, required this.deck});

  @override
  _FlashcardIndexScreenState createState() => _FlashcardIndexScreenState();
}

class _FlashcardIndexScreenState extends State<FlashcardIndexScreen> {
  late Future<void> _flashcardsFuture;

  @override
  void initState() {
    super.initState();
    final String? token = context.read<UserModel>().token;
    _flashcardsFuture = Provider.of<FlashcardProvider>(context, listen: false).fetchAndPopulateFlashcards(token!, widget.deck.id);
    context.read<ProviderUserLogin>().expandTelegram();
  }

  void _reloadFlashcards() {
    final String? token = context.read<UserModel>().token;
    setState(() {
      _flashcardsFuture = Provider.of<FlashcardProvider>(context, listen: false).fetchAndPopulateFlashcards(token!, widget.deck.id);
    });
  }

  Widget _buildCardItem(BuildContext context, FlashcardModel card, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: SwipeableCard(
        flashcard: card,
        deck: widget.deck,

        ///TODO: DO NOT DELETE THIS COMMENT !!!!!
        // onRemove: () {
        //  // context.read<FlashcardProvider>().updateCardWeight(card.id, 1);
        // },
        // onSwipe: (increment) {
        //  // context.read<FlashcardProvider>().updateCardWeight(card.id, increment);
        // },
        // onIncrease: (increment) {
        //   context.read<FlashcardProvider>().updateCardWeight(card.id, increment);
        // },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String? token = context.read<UserModel>().token;
    var txt = FlashcardIndexScreenTranslate(context.read<UserModel>().language_code ?? 'en');

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.deck.name),
        actions: [
          IconButton(
            icon: Icon(Icons.edit_note), // Первая кнопка
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DeckSettingsScreen(
                    deck: widget.deck,
                  ),
                ),
              );
              // Перезагрузка после возврата
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _flashcardsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('An error occurred: ${snapshot.error}'));
          } else {
            return Consumer<FlashcardProvider>(
              builder: (context, flashcardProvider, child) {
                return AnimatedList(
                  key: flashcardProvider.listKey,
                  initialItemCount: flashcardProvider.flashcards.length,
                  itemBuilder: (context, index, animation) {
                    final flashcard = flashcardProvider.flashcards[index];
                    return _buildCardItem(context, flashcard, animation);
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'add_own_deck',
        onPressed: () {
          Navigator.of(context)
              .push(
                MaterialPageRoute(
                  builder: (context) => FlashcardManagementScreen(
                    deck: widget.deck,
                    token: token!,
                  ),
                ),
              )
              .then(
                (_) => _reloadFlashcards(),
              );
        },
        label: Text(
          txt.tt('add_flashcard'),
          // style: TextStyle(
          //   fontSize: (baseFontSize).clamp(10.0, 25.0),
          // ),
        ),
        icon: const Icon(Icons.add_box_outlined),
      ),
    );
  }
}
