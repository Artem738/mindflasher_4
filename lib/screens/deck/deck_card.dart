import 'package:flutter/material.dart';
import 'package:mindflasher_4/models/deck_model.dart';
import 'package:mindflasher_4/screens/list/flashcard_index_screen.dart';

class DeckCard extends StatelessWidget {
  final DeckModel deck;
  final double baseFontSize;
  final bool isClickOnCardWork;

  const DeckCard({
    Key? key,
    required this.deck,
    required this.baseFontSize,
    this.isClickOnCardWork = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4, // Добавляет тень для визуального выделения
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 16), // Отступы
      child: ListTile(
        title: Text(
          deck.name,
          style: TextStyle(fontSize: baseFontSize + 2),
        ),
        subtitle: Text(
          deck.description,
          style: TextStyle(fontSize: baseFontSize),
        ),
        onTap: () {
          if (isClickOnCardWork) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => FlashcardIndexScreen(deck: deck),
              ),
            );
          }
        },
      ),
    );
  }
}
