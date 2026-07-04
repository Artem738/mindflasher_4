import 'package:flutter/material.dart';
import 'package:mindflasher_4/models/template_category_model.dart';
import 'package:mindflasher_4/providers/provider_user_control.dart';
import 'package:mindflasher_4/screens/template_flashcard_index_screen.dart';
import 'package:mindflasher_4/translates/template_deck_index_screen_translate.dart';
import 'package:provider/provider.dart';

class TemplateDecksListScreen extends StatelessWidget {
  final TemplateCategoryModel subcategory;

  const TemplateDecksListScreen({super.key, required this.subcategory});

  @override
  Widget build(BuildContext context) {
    final baseFontSize = context.read<ProviderUserControl>().userModel.base_font_size;
    var txt = TemplateDeckIndexScreenTranslate(context.read<ProviderUserControl>().userModel.language_code ?? 'en');

    return Scaffold(
      appBar: AppBar(
        title: Text(subcategory.name),
      ),
      body: subcategory.decks.isEmpty
          ? Center(
              child: Text(
                'No template decks in this category', // Simple placeholder, fallback to english or default
                style: TextStyle(fontSize: baseFontSize),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              itemCount: subcategory.decks.length,
              separatorBuilder: (ctx, i) => const SizedBox(height: 12.0),
              itemBuilder: (ctx, i) {
                final deck = subcategory.decks[i];
                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(ctx).colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(ctx).colorScheme.outlineVariant.withOpacity(0.5),
                    ),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => TemplateFlashcardIndexScreen(deck: deck),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  deck.name,
                                  style: TextStyle(
                                    fontSize: baseFontSize + 2,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(ctx).colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Divider(
                                  color: Theme.of(ctx).colorScheme.outlineVariant.withOpacity(0.3),
                                  thickness: 1,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  deck.description,
                                  style: TextStyle(
                                    fontSize: baseFontSize,
                                    color: Theme.of(ctx).colorScheme.onSurfaceVariant,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Theme.of(ctx).colorScheme.primaryContainer.withOpacity(0.4),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.style_outlined,
                                            size: 14,
                                            color: Theme.of(ctx).colorScheme.primary,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            '${deck.flashcardsCount ?? 0} ${txt.tt('cards_count')}',
                                            style: TextStyle(
                                              fontSize: baseFontSize - 2,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(ctx).colorScheme.primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.chevron_right_rounded,
                            color: Theme.of(ctx).colorScheme.onSurfaceVariant.withOpacity(0.7),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
