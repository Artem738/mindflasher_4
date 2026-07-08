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

  const FlashcardManagementScreen({super.key, required this.deck, this.flashcard});

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

  void _wrapWithVoiceTag(TextEditingController controller) {
    final text = controller.text;
    final selection = controller.selection;

    if (selection.isValid) {
      if (!selection.isCollapsed) {
        final selectedText = text.substring(selection.start, selection.end);
        final newText = text.replaceRange(selection.start, selection.end, '[v]$selectedText[/v]');
        controller.value = TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: selection.start + 3 + selectedText.length + 4),
        );
      } else {
        final newText = text.replaceRange(selection.start, selection.end, '[v][/v]');
        controller.value = TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: selection.start + 3),
        );
      }
    } else {
      controller.text = '$text[v][/v]';
      controller.selection = TextSelection.collapsed(offset: controller.text.length - 4);
    }
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
        actions: [
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              color: Theme.of(context).colorScheme.error,
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text(txt.tt('delete_confirmation_title')),
                    content: Text(txt.tt('delete_confirmation_content')),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(false),
                        child: Text(txt.tt('cancel_button')),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.of(ctx).pop(true),
                        style: FilledButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.error,
                        ),
                        child: Text(txt.tt('delete_button')),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  final flashcardProvider = context.read<FlashcardProvider>();
                  bool success = await flashcardProvider.deleteFlashcard(widget.flashcard!.id);
                  if (success) {
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(txt.tt('failed_to_delete_flashcard')),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  }
                }
              },
            ),
        ],
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
              maxLines: 1,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.volume_up, size: 24),
                  tooltip: '[v] [/v]',
                  onPressed: () => _wrapWithVoiceTag(_answerController),
                ),
              ],
            ),
            TextField(
              controller: _answerController,
              decoration: InputDecoration(
                labelText: txt.tt('answer_label'),
                alignLabelWithHint: true,
              ),
              maxLines: 20,
              minLines: 5,
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
                  if (flashcardProvider.flashcards.length >= 1000) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(txt.tt('limit_reached')),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Theme.of(context).colorScheme.error,
                      ),
                    );
                    return;
                  }
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

          ],
        ),
      ),
    );
  }
}
