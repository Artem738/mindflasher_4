import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mindflasher_4/models/deck_model.dart';
import 'package:mindflasher_4/models/flashcard_model.dart';
import 'package:mindflasher_4/models/user_model.dart';
import 'package:mindflasher_4/screens/deck/deck_index_screen.dart';
import 'package:mindflasher_4/translates/csv_management_screen_translate.dart';
import 'package:provider/provider.dart';
import 'package:mindflasher_4/providers/flashcard_provider.dart';

class CsvManagementScreen extends StatefulWidget {
  final DeckModel deck;
  final List<FlashcardModel>? exportFlashcards;

  const CsvManagementScreen({
    super.key,
    required this.deck,
    this.exportFlashcards,
  });

  @override
  _CsvManagementScreenState createState() => _CsvManagementScreenState();
}

class _CsvManagementScreenState extends State<CsvManagementScreen> {
  late TextEditingController _csvController;
  String _selectedDelimiter = ';';
  final List<String> _delimiters = [';', ',', '\t', '|'];

  @override
  void initState() {
    super.initState();
    _csvController = TextEditingController();
    _generateExportData();
  }

  void _generateExportData() {
    if (widget.exportFlashcards != null) {
      final csvLines = widget.exportFlashcards!.map((card) {
        return '${card.question}$_selectedDelimiter${card.answer}';
      }).toList();
      _csvController.text = csvLines.join('\n');
    }
  }

  @override
  void dispose() {
    _csvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var txt = CsvManagementScreenTranslate(context.read<UserModel>().language_code ?? 'en');
    final isExportMode = widget.exportFlashcards != null;
    final title = isExportMode ? txt.tt('export_csv_title') : txt.tt('import_csv_title');

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  txt.tt('delimiter_label'),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 16),
                DropdownButton<String>(
                  value: _selectedDelimiter,
                  items: _delimiters.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value == '\t' ? 'Tab' : value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedDelimiter = newValue;
                        _generateExportData();
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              isExportMode ? txt.tt('generate_csv_data') : txt.tt('enter_csv_data'),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _csvController,
              maxLines: 20,
              readOnly: isExportMode,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: isExportMode ? '' : txt.tt('csv_placeholder'),
              ),
            ),
            const SizedBox(height: 20),
            if (isExportMode)
              ElevatedButton.icon(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: _csvController.text));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(txt.tt('copied_message'))),
                  );
                },
                icon: const Icon(Icons.copy),
                label: Text(txt.tt('copy_button')),
              )
            else
              ElevatedButton(
                onPressed: () async {
                  final flashcardProvider = context.read<FlashcardProvider>();
                  bool success = await flashcardProvider.csvInsert(
                    widget.deck.id,
                    _csvController.text,
                    delimiter: _selectedDelimiter,
                  );
                  if (success) {
                    if (context.mounted) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DeckIndexScreen(),
                        ),
                        (Route<dynamic> route) => false,
                      );
                    }
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(txt.tt('failed_csv_insert'))),
                      );
                    }
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
