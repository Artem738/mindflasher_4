import 'package:flutter/material.dart';
import 'package:mindflasher_4/models/deck_model.dart';
import 'package:mindflasher_4/models/user_model.dart';
import 'package:mindflasher_4/providers/deck_provider.dart';
import 'package:mindflasher_4/screens/deck/deck_index_screen.dart';
import 'package:mindflasher_4/translates/deck_management_screen_translate.dart';
import 'package:provider/provider.dart';

class DeckManagementScreen extends StatefulWidget {
  final DeckModel? deck;
  final String token;

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
    var txt = DeckManagementScreenTranslate(context.read<UserModel>().language_code ?? 'en');
    final isEditing = widget.deck != null;
    final title = isEditing ? ("${txt.tt('edit_deck_title')} ${widget.deck!.name}") : txt.tt('create_deck_title');
    final actionButtonLabel = isEditing ? txt.tt('update_button') : txt.tt('create_button');

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
              decoration: InputDecoration(labelText: txt.tt('deck_name_label')),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: txt.tt('description_label')),
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
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DeckIndexScreen(),
                      ),
                      (Route<dynamic> route) => false,
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(txt.tt('failed_to_update_deck'))),
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
                      SnackBar(content: Text(txt.tt('failed_to_create_deck'))),
                    );
                  }
                }
              },
              child: Text(actionButtonLabel),
            ),
          ],
        ),
      ),
    );
  }
}
