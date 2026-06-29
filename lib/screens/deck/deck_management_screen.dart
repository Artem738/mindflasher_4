import 'package:flutter/material.dart';
import 'package:mindflasher_4/models/deck_model.dart';
import 'package:mindflasher_4/models/user_model.dart';
import 'package:mindflasher_4/providers/deck_provider.dart';
import 'package:mindflasher_4/translates/deck_management_screen_translate.dart';
import 'package:provider/provider.dart';

class DeckManagementScreen extends StatefulWidget {
  final DeckModel? deck;

  const DeckManagementScreen({super.key, this.deck});

  @override
  _DeckManagementScreenState createState() => _DeckManagementScreenState();
}

class _DeckManagementScreenState extends State<DeckManagementScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  final _formKey = GlobalKey<FormState>();

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
    final userModel = context.read<UserModel>();
    final baseFontSize = userModel.base_font_size;
    final colorScheme = Theme.of(context).colorScheme;

    var txt = DeckManagementScreenTranslate(userModel.language_code ?? 'en');
    final isEditing = widget.deck != null;
    final title = isEditing 
        ? ("${txt.tt('edit_deck_title')} ${widget.deck!.name}") 
        : txt.tt('create_deck_title');
    final actionButtonLabel = isEditing ? txt.tt('update_button') : txt.tt('create_button');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(
            fontSize: (baseFontSize + 2).clamp(16.0, 22.0),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Иконка вверху страницы
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isEditing ? Icons.edit_note : Icons.collections_bookmark_outlined,
                      size: 64,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                
                // Карточка формы ввода
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Поле ввода имени колоды
                        TextFormField(
                          controller: _nameController,
                          style: TextStyle(fontSize: baseFontSize.clamp(14.0, 20.0)),
                          decoration: InputDecoration(
                            labelText: txt.tt('deck_name_label'),
                            prefixIcon: const Icon(Icons.bookmark_outline),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter a name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        
                        // Поле ввода описания колоды
                        TextFormField(
                          controller: _descriptionController,
                          style: TextStyle(fontSize: baseFontSize.clamp(14.0, 20.0)),
                          maxLines: 3,
                          minLines: 2,
                          decoration: InputDecoration(
                            labelText: txt.tt('description_label'),
                            prefixIcon: const Icon(Icons.description_outlined),
                            alignLabelWithHint: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                
                // Кнопка действия
                FilledButton.icon(
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }

                    final deckProvider = context.read<DeckProvider>();

                    if (isEditing) {
                      // Обновление колоды
                      bool success = await deckProvider.updateDeck(
                        widget.deck!.id,
                        _nameController.text.trim(),
                        _descriptionController.text.trim(),
                      );
                      if (success) {
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(txt.tt('failed_to_update_deck')),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    } else {
                      // Добавление новой колоды
                      bool success = await deckProvider.createDeck(
                        _nameController.text.trim(),
                        _descriptionController.text.trim(),
                      );
                      if (success) {
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(txt.tt('failed_to_create_deck')),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    }
                  },
                  icon: Icon(isEditing ? Icons.check_circle_outline : Icons.add_circle_outline),
                  label: Text(
                    actionButtonLabel,
                    style: TextStyle(
                      fontSize: (baseFontSize + 2).clamp(16.0, 22.0),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

