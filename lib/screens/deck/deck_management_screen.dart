import 'package:flutter/material.dart';
import 'package:mindflasher_4/models/deck_model.dart';
import 'package:mindflasher_4/providers/deck_provider.dart';
import 'package:provider/provider.dart';

class DeckManagementScreen extends StatefulWidget {
  final DeckModel? deck; // Если передана колода, значит, выполняется редактирование
  final String token; // Токен для API-запросов

  const DeckManagementScreen({Key? key, this.deck, required this.token}) : super(key: key);

  @override
  _DeckManagementScreenState createState() => _DeckManagementScreenState();
}

class _DeckManagementScreenState extends State<DeckManagementScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    // Если редактирование, инициализируем контроллеры значениями из переданной колоды
    _nameController = TextEditingController(text: widget.deck?.name ?? '');
    _descriptionController = TextEditingController(text: widget.deck?.description ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.deck != null;
    final title = isEditing ? 'Edit Deck' : 'Create Deck';
    final actionButtonLabel = isEditing ? 'Update' : 'Add';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Deck Name'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final deckProvider = context.read<DeckProvider>();

                if (isEditing) {
                  // Обновление колоды
                  bool success = await deckProvider.updateDeck(
                    widget.deck!.id,
                    _nameController.text,
                    _descriptionController.text,
                    widget.token,
                  );
                  if (success) {
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to update deck')),
                    );
                  }
                } else {
                  // Добавление новой колоды
                  bool success = await deckProvider.createDeck(
                    _nameController.text,
                    _descriptionController.text,
                    widget.token,
                  );
                  if (success) {
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to create deck')),
                    );
                  }
                }
              },
              child: Text(actionButtonLabel),
            ),
            if (isEditing) ...[
              ElevatedButton(
                onPressed: () async {
                  final deckProvider = context.read<DeckProvider>();

                  // Удаление колоды
                  bool success = await deckProvider.deleteDeck(widget.deck!.id, widget.token);
                  if (success) {
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to delete deck')),
                    );
                  }
                },
                child: Text('Delete'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Цвет кнопки удаления
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
