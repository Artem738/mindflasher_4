import 'package:flutter/material.dart';
import 'package:mindflasher_4/models/deck_model.dart';
import 'package:mindflasher_4/models/flashcard_model.dart';
import 'package:mindflasher_4/models/user_model.dart';
import 'package:mindflasher_4/providers/flashcard_provider.dart';
import 'package:mindflasher_4/translates/flashcard_management_screen_translate.dart';
import 'package:provider/provider.dart';

class FlashcardManagementScreen extends StatefulWidget {
  final DeckModel deck; //
  final FlashcardModel? flashcard; // Если передана карточка, значит, выполняется редактирование
  final String token; // Токен для API-запросов

  const FlashcardManagementScreen({Key? key, required this.deck, this.flashcard, required this.token}) : super(key: key);

  @override
  _FlashcardManagementScreenState createState() => _FlashcardManagementScreenState();
}

class _FlashcardManagementScreenState extends State<FlashcardManagementScreen> {
  late TextEditingController _questionController;
  late TextEditingController _answerController;

  @override
  void initState() {
    super.initState();
    // Если редактирование, инициализируем контроллеры значениями из переданной карточки
    _questionController = TextEditingController(text: widget.flashcard?.question ?? '');
    _answerController = TextEditingController(text: widget.flashcard?.answer ?? '');
  }

  @override
  void dispose() {
    _questionController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var txt = FlashcardManagementScreenTranslate(context.read<UserModel>().language_code ?? 'en');
    final isEditing = widget.flashcard != null;
    final title = isEditing ? txt.tt('edit_flashcard_title') : txt.tt('create_flashcard_title');
    final actionButtonLabel = isEditing ? txt.tt('update_button') :txt.tt('add_button');

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _questionController,
              decoration: InputDecoration(labelText: txt.tt('question_label') ),
            ),
            TextField(
              controller: _answerController,
              decoration: InputDecoration(labelText: txt.tt('answer_label')),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final flashcardProvider = context.read<FlashcardProvider>();

                if (isEditing) {
                  // Обновление карточки
                  bool success = await flashcardProvider.updateFlashcard(
                    widget.deck.id,
                    widget.flashcard!.id,
                    _questionController.text,
                    _answerController.text,
                    widget.token,
                  );
                  if (success) {
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(txt.tt('failed_to_update_flashcard'))),
                    );
                  }
                } else {
                  // Добавление новой карточки
                  bool success = await flashcardProvider.createFlashcard(
                    widget.deck.id,
                    _questionController.text,
                    _answerController.text,
                    widget.token,
                  );
                  if (success) {
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(txt.tt('failed_to_create_flashcard'))),
                    );
                  }
                }
              },
              child: Text(actionButtonLabel),
            ),
            if (isEditing)
              ElevatedButton(
                onPressed: () async {
                  /// Удаление карточки
                  final flashcardProvider = context.read<FlashcardProvider>();
                  bool success = await flashcardProvider.deleteFlashcard(widget.flashcard!.id, widget.token);
                  if (success) {
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text( txt.tt('failed_to_update_flashcard'))),
                    );
                  }
                },
                child: Text(txt.tt('delete_button')),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Цвет кнопки удаления
                ),
              ),
          ],
        ),
      ),
    );
  }
}
