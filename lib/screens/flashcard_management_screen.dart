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

  const FlashcardManagementScreen({Key? key, required this.deck, this.flashcard}) : super(key: key);

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _questionController,
              decoration: InputDecoration(
                labelText: txt.tt('question_label'),
                alignLabelWithHint: true,
              ),
              maxLines: 3,
              minLines: 1,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _answerController,
              decoration: InputDecoration(
                labelText: txt.tt('answer_label'),
                alignLabelWithHint: true,
              ),
              maxLines: 5,
              minLines: 1,
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: () async {
                final flashcardProvider = context.read<FlashcardProvider>();

                if (isEditing) {
                  // Обновление карточки
                  bool success = await flashcardProvider.updateFlashcard(
                    widget.deck.id,
                    widget.flashcard!.id,
                    _questionController.text,
                    _answerController.text,
                  );
                  if (success) {
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(txt.tt('failed_to_update_flashcard')),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                } else {
                  // Добавление новой карточки
                  bool success = await flashcardProvider.createFlashcard(
                    widget.deck.id,
                    _questionController.text,
                    _answerController.text,
                  );
                  if (success) {
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(txt.tt('failed_to_create_flashcard')),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                }
              },
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                actionButtonLabel,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            if (isEditing) ...[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () async {
                  final flashcardProvider = context.read<FlashcardProvider>();
                  bool success = await flashcardProvider.deleteFlashcard(widget.flashcard!.id);
                  if (success) {
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(txt.tt('failed_to_update_flashcard')),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.delete_outline),
                label: Text(txt.tt('delete_button')),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                  side: BorderSide(color: Theme.of(context).colorScheme.error),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
