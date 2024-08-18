import 'package:flutter/material.dart';
import 'package:mindflasher_4/models/deck_model.dart';
import 'package:mindflasher_4/models/flashcard_model.dart';
import 'package:mindflasher_4/models/user_model.dart';
import 'package:mindflasher_4/providers/deck_provider.dart';
import 'package:mindflasher_4/providers/flashcard_provider.dart';
import 'package:mindflasher_4/providers/provider_user_login.dart';
import 'package:mindflasher_4/screens/deck/deck_index_screen.dart';
import 'package:mindflasher_4/screens/flashcard_management_screen.dart';
import 'package:provider/provider.dart';
import 'swipeable_card.dart';

class FlashcardIndexScreen extends StatefulWidget {
  final DeckModel deck;

  FlashcardIndexScreen({required this.deck});

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

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.deck.name),
        actions: [
          IconButton(
            icon: Icon(Icons.add_box_outlined), // Первая кнопка
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
                  .then((_) => _reloadFlashcards()); // Перезагрузка после возврата
            },
          ),
          IconButton(
            icon: Icon(Icons.delete_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Text(
                      'Вы уверены, что хотите удалить этот элемент?',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    actions: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center, // Центрирование кнопок
                        children: <Widget>[
                          TextButton(
                            onPressed: () {
                              context.read<DeckProvider>().deleteDeck(widget.deck.id, token!);
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) => DeckIndexScreen()),
                                (Route<dynamic> route) => false,
                              );
                            },
                            child: Text(
                              'Удалить',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          SizedBox(width: 20), // Пробел между кнопками
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Закрываем диалог
                            },
                            child: Text(
                              'Отмена !',
                              style: TextStyle(fontSize: 21),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              );
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
    );
  }
}
