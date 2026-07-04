import 'package:flutter/material.dart';
import 'package:mindflasher_4/models/deck_model.dart';
import 'package:mindflasher_4/providers/deck_provider.dart';
import 'package:mindflasher_4/providers/flashcard_provider.dart';
import 'package:mindflasher_4/providers/provider_user_control.dart';
import 'package:mindflasher_4/screens/csv_management_screen.dart';
import 'package:mindflasher_4/screens/deck/deck_index_screen.dart';
import 'package:mindflasher_4/screens/deck/deck_management_screen.dart';
import 'package:mindflasher_4/screens/import_table_screen.dart';
import 'package:mindflasher_4/screens/flashcard_management_screen.dart';
// Добавлен новый экран
import 'package:mindflasher_4/translates/deck_settings_screen_translate.dart';
import 'package:provider/provider.dart';

class DeckSettingsScreen extends StatelessWidget {
  final DeckModel deck;

  const DeckSettingsScreen({super.key, required this.deck});

  @override
  Widget build(BuildContext context) {
    final userControl = context.watch<ProviderUserControl>();
    final userModel = userControl.userModel;
    final baseFontSize = userModel.base_font_size;
    final colorScheme = Theme.of(context).colorScheme;
    var txt = DeckSettingsScreenTranslate (userModel.language_code ?? 'en');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          txt.tt('deck_settings_title'),
          style: TextStyle(
            fontSize: (baseFontSize + 2).clamp(16.0, 22.0),
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: ModalRoute.of(context)?.canPop == true
            ? null // Если есть роут возврата, оставляем стандартный AppBar
            : IconButton(
                // Если роута возврата нет, добавляем свою кнопку
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const DeckIndexScreen(),
                    ),
                  );
                },
              ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            color: Colors.redAccent,
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Text(
                      txt.tt('delete_confirmation') ,
                      style: TextStyle(fontSize: (baseFontSize + 4).clamp(16.0, 24.0)),
                      textAlign: TextAlign.center,
                    ),
                    actions: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center, // Центрирование кнопок
                        children: <Widget>[
                          TextButton(
                            onPressed: () {
                              context.read<DeckProvider>().deleteDeck(deck.id);
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) => const DeckIndexScreen()),
                                (Route<dynamic> route) => false,
                              );
                            },
                            child: Text(
                              txt.tt('delete_button'),
                              style: TextStyle(
                                  fontSize: baseFontSize.clamp(14.0, 19.0),
                                  color: Colors.red,
                              ),
                            ),
                          ),
                          const SizedBox(width: 20), // Пробел между кнопками
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Закрываем диалог
                            },
                            child: Text(
                              txt.tt('cancel_button'),
                              style: TextStyle(fontSize: (baseFontSize + 3).clamp(15.0, 22.0)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Карточка с информацией о колоде
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: colorScheme.primaryContainer.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.collections_bookmark,
                              size: 32,
                              color: colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  deck.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: (baseFontSize + 3).clamp(16.0, 24.0),
                                  ),
                                ),
                                if (deck.description.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    deck.description,
                                    style: TextStyle(
                                      color: colorScheme.onSurfaceVariant,
                                      fontSize: (baseFontSize - 1).clamp(12.0, 18.0),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(height: 1),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            txt.tt('deck_id'),
                            style: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                              fontSize: baseFontSize.clamp(14.0, 19.0),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '#${deck.id}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.primary,
                                fontSize: baseFontSize.clamp(13.0, 18.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Карточка с кнопками управления
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    // Добавить флеш-карточку
                    ListTile(
                      leading: const Icon(Icons.add_box_outlined),
                      title: Text(
                        txt.tt('add_flashcard'),
                        style: TextStyle(fontSize: baseFontSize.clamp(14.0, 20.0)),
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FlashcardManagementScreen(
                              deck: deck,
                            ),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 1),

                    // Редактировать колоду
                    ListTile(
                      leading: const Icon(Icons.edit_outlined),
                      title: Text(
                        txt.tt('edit_deck'),
                        style: TextStyle(fontSize: baseFontSize.clamp(14.0, 20.0)),
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DeckManagementScreen(
                              deck: deck,
                            ),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 1),
                    
                    // Импортировать таблицу
                    ListTile(
                      leading: const Icon(Icons.import_contacts_outlined),
                      title: Text(
                        txt.tt('import_table'),
                        style: TextStyle(fontSize: baseFontSize.clamp(14.0, 20.0)),
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ImportTableScreen(
                              deck: deck,
                            ),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 1),
                    
                    // Вставить CSV
                    ListTile(
                      leading: const Icon(Icons.upload_file_outlined),
                      title: Text(
                        txt.tt('csv_insert'),
                        style: TextStyle(fontSize: baseFontSize.clamp(14.0, 20.0)),
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CsvManagementScreen(
                              deck: deck,
                            ),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 1),
                    
                    // Получить CSV
                    ListTile(
                      leading: const Icon(Icons.download_for_offline_outlined),
                      title: Text(
                        txt.tt('csv_get_data'),
                        style: TextStyle(fontSize: baseFontSize.clamp(14.0, 20.0)),
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () async {
                        final flashcardProvider = context.read<FlashcardProvider>();
                        try {
                          final allFlashcards = await flashcardProvider.fetchAllFlashcardsForExport(deck.id);
                          if (context.mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CsvManagementScreen(
                                  deck: deck,
                                  exportFlashcards: allFlashcards,
                                ),
                              ),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Failed to load flashcards for export')),
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              // Кнопка На главную
              FilledButton.icon(
                onPressed: () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const DeckIndexScreen()),
                    );
                  }
                },
                icon: const Icon(Icons.home_outlined),
                label: Text(
                  txt.tt('to_main'),
                  style: TextStyle(
                    fontSize: (baseFontSize + 2).clamp(16.0, 22.0),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.lightGreen,
                  foregroundColor: Colors.black87,
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
    );
  }
}
