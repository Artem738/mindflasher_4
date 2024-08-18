import 'package:flutter/material.dart';
import 'package:mindflasher_4/models/deck_model.dart';
import 'package:mindflasher_4/models/flashcard_model.dart';
import 'package:mindflasher_4/models/user_model.dart';
import 'package:mindflasher_4/providers/deck_provider.dart';
import 'package:mindflasher_4/providers/flashcard_provider.dart';
import 'package:mindflasher_4/screens/flashcard_management_screen.dart';
import 'package:mindflasher_4/tech_data/weight_delays_enum.dart';

import 'package:provider/provider.dart';

class LeftSwipeCard extends StatelessWidget {
  final DeckModel deck;
  final FlashcardModel flashcard;
  final double stopThreshold;

  const LeftSwipeCard({
    Key? key,
    required this.deck,
    required this.flashcard,
    required this.stopThreshold,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String? token = context.read<UserModel>().token;
    return Align(
      alignment: Alignment.centerLeft,
      child: FractionallySizedBox(
        widthFactor: stopThreshold,
        child: Card(
          surfaceTintColor: Colors.blueAccent.withOpacity(0.05),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => FlashcardManagementScreen(
                          deck: deck,
                          token: token!,
                          flashcard: flashcard,
                        ),
                      ),
                    );
                    // Provider.of<FlashcardProvider>(context, listen: false).updateCardWeight(token!, flashcard.id, WeightDelaysEnum.noDelay);
                    // Provider.of<FlashcardProvider>(context, listen: false).updateCardWeight(token!, flashcard.id, WeightDelaysEnum.noDelay);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.zero,
                  ),
                  child: Center(
                    child: Icon(Icons.edit_note, color: Colors.white),
                  ),
                ),
                Column(
                  children: [
                    Text("ID: ${flashcard.id} "),
                    Text("Weight: ${flashcard.weight} "),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
