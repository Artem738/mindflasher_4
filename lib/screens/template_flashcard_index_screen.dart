import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:mindflasher_4/models/template_deck_model.dart';
import 'package:mindflasher_4/providers/provider_user_control.dart';
import 'package:mindflasher_4/providers/template_flashcard_provider.dart';
import 'package:mindflasher_4/providers/deck_provider.dart';
import 'package:mindflasher_4/models/deck_model.dart';
import 'package:mindflasher_4/screens/list/flashcard_index_screen.dart';
import 'package:mindflasher_4/translates/template_flashcard_index_screen_translate.dart';
import 'package:provider/provider.dart';

class TemplateFlashcardIndexScreen extends StatefulWidget {
  final TemplateDeckModel deck;

  const TemplateFlashcardIndexScreen({super.key, required this.deck});

  @override
  State<TemplateFlashcardIndexScreen> createState() => _TemplateFlashcardIndexScreenState();
}

class _TemplateFlashcardIndexScreenState extends State<TemplateFlashcardIndexScreen> {
  late Future<void> _fetchFlashcardsFuture;

  @override
  void initState() {
    super.initState();
    _fetchFlashcardsFuture = context.read<TemplateFlashcardProvider>().fetchFlashcards(widget.deck.id);
  }

  @override
  Widget build(BuildContext context) {
    final deck = widget.deck;
    final baseFontSize = context.read<ProviderUserControl>().userModel.base_font_size;
    var txt = TemplateFlashcardIndexScreenTranslate(context.read<ProviderUserControl>().userModel.language_code ?? 'en');
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final userDecks = context.watch<DeckProvider>().decks;
    DeckModel? existingDeck;
    for (var d in userDecks) {
      if (d.templateDeckId == deck.id) {
        existingDeck = d;
        break;
      }
    }
    final bool isAdded = existingDeck != null;

    // Настройка стилей для markdown на основе базового размера шрифта пользователя
    final baseMarkdownConfig = isDark ? MarkdownConfig.darkConfig : MarkdownConfig.defaultConfig;
    final markdownConfig = baseMarkdownConfig.copy(
      configs: [
        PConfig(
          textStyle: TextStyle(
            fontSize: baseFontSize,
            height: 1.5,
          ),
        ),
        H1Config(
          style: TextStyle(
            fontSize: baseFontSize * 1.5,
            fontWeight: FontWeight.bold,
          ),
        ),
        H2Config(
          style: TextStyle(
            fontSize: baseFontSize * 1.35,
            fontWeight: FontWeight.bold,
          ),
        ),
        H3Config(
          style: TextStyle(
            fontSize: baseFontSize * 1.2,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${deck.name} ${deck.deck_lang}',
          style: TextStyle(fontSize: (baseFontSize + 5).clamp(15.0 + 5, 20.0 + 5)),
        ),
      ),
      body: FutureBuilder(
        future: _fetchFlashcardsFuture,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'An error occurred: ${snapshot.error}',
                style: TextStyle(fontSize: (baseFontSize).clamp(15.0, 20.0)),
              ),
            );
          } else {
            final flashcardProvider = context.read<TemplateFlashcardProvider>();
            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    cacheExtent: 5000,
                    padding: const EdgeInsets.all(16.0),
                    itemCount: flashcardProvider.templateFlashcards.length,
                    separatorBuilder: (ctx, i) => const SizedBox(height: 16.0),
                    itemBuilder: (ctx, i) {
                      final card = flashcardProvider.templateFlashcards[i];
                      return Container(
                        decoration: BoxDecoration(
                          color: Theme.of(ctx).colorScheme.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Theme.of(ctx).colorScheme.outlineVariant.withOpacity(0.5),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Метка "Вопрос"
                              Row(
                                children: [
                                  Icon(
                                    Icons.help_outline,
                                    size: 16,
                                    color: Theme.of(ctx).colorScheme.primary,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    txt.tt('question').toUpperCase(),
                                    style: TextStyle(
                                      fontSize: baseFontSize * 0.8,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(ctx).colorScheme.primary,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              // Блок Markdown с текстом вопроса
                              MarkdownBlock(
                                data: card.question,
                                config: markdownConfig,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12.0),
                                child: Divider(
                                  color: Theme.of(ctx).colorScheme.outlineVariant.withOpacity(0.3),
                                  thickness: 1,
                                ),
                              ),
                              // Метка "Ответ"
                              Row(
                                children: [
                                  Icon(
                                    Icons.check_circle_outline,
                                    size: 16,
                                    color: Theme.of(ctx).colorScheme.secondary,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    txt.tt('answer').toUpperCase(),
                                    style: TextStyle(
                                      fontSize: baseFontSize * 0.8,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(ctx).colorScheme.secondary,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              // Блок Markdown с текстом ответа
                              MarkdownBlock(
                                data: card.answer,
                                config: markdownConfig,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: isAdded
                          ? ElevatedButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).clearSnackBars();
                                Navigator.of(context).popUntil((route) => route.isFirst);
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => FlashcardIndexScreen(deck: existingDeck!),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 2,
                              ),
                              icon: const Icon(Icons.play_circle_outline),
                              label: Text(
                                txt.tt('go_to_study'),
                                style: TextStyle(
                                  fontSize: baseFontSize.clamp(14.0, 18.0),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          : ElevatedButton.icon(
                              onPressed: () async {
                                bool success = await context
                                    .read<TemplateFlashcardProvider>()
                                    .addTemplateBaseToUser(context, deck.id);
                                if (success) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      margin: const EdgeInsets.only(bottom: 80, left: 16, right: 16),
                                      content: Text(
                                        txt.tt('template_base_added'),
                                        style: TextStyle(fontSize: (baseFontSize).clamp(10.0, 25.0)),
                                      ),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      margin: const EdgeInsets.only(bottom: 80, left: 16, right: 16),
                                      content: Text(
                                        txt.tt('failed_to_add'),
                                        style: TextStyle(fontSize: (baseFontSize).clamp(10.0, 25.0)),
                                      ),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                                foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 2,
                              ),
                              icon: const Icon(Icons.download_outlined),
                              label: Text(
                                txt.tt('make_your_own'),
                                style: TextStyle(
                                  fontSize: baseFontSize.clamp(14.0, 18.0),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
