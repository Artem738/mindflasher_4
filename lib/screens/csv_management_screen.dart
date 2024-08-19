import 'package:flutter/material.dart';
import 'package:mindflasher_4/models/deck_model.dart';
import 'package:mindflasher_4/models/user_model.dart';
import 'package:mindflasher_4/screens/deck/deck_index_screen.dart';
import 'package:mindflasher_4/translates/csv_management_screen_translate.dart';
import 'package:provider/provider.dart';
import 'package:mindflasher_4/providers/flashcard_provider.dart';

class CsvManagementScreen extends StatefulWidget {
  final DeckModel deck;
  final String token;
  final String? csvData;

  const CsvManagementScreen({
    Key? key,
    required this.deck,
    required this.token,
    this.csvData,
  }) : super(key: key);

  @override
  _CsvManagementScreenState createState() => _CsvManagementScreenState();
}

class _CsvManagementScreenState extends State<CsvManagementScreen> {
  late TextEditingController _csvController;

  @override
  void initState() {
    super.initState();
    _csvController = TextEditingController(text: widget.csvData ?? '');
  }

  @override
  void dispose() {
    _csvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var txt = CsvManagementScreenTranslate(context.read<UserModel>().language_code ?? 'en');

    return Scaffold(
      appBar: AppBar(
        title: Text(txt.tt('csv_management_title')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              txt.tt('enter_csv_data'),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _csvController,
              maxLines: 20,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: txt.tt('csv_placeholder'),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final flashcardProvider = context.read<FlashcardProvider>();
                bool success = await flashcardProvider.csvInsert(
                  widget.deck.id,
                  _csvController.text,
                  widget.token,
                );
                if (success) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DeckIndexScreen(),
                    ),
                    (Route<dynamic> route) => false,
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(txt.tt('failed_csv_insert'))),
                  );
                }
              },
              child: Text(txt.tt('upload_csv_button')),
            ),
          ],
        ),
      ),
    );
  }
}
