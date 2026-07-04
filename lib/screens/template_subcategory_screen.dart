import 'package:flutter/material.dart';
import 'package:mindflasher_4/models/template_category_model.dart';
import 'package:mindflasher_4/providers/provider_user_control.dart';
import 'package:mindflasher_4/screens/template_decks_list_screen.dart';
import 'package:mindflasher_4/translates/template_deck_index_screen_translate.dart';
import 'package:provider/provider.dart';

class TemplateSubcategoryScreen extends StatelessWidget {
  final TemplateCategoryModel category;

  const TemplateSubcategoryScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final baseFontSize = context.read<ProviderUserControl>().userModel.base_font_size;
    var txt = TemplateDeckIndexScreenTranslate(context.read<ProviderUserControl>().userModel.language_code ?? 'en');

    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
      ),
      body: category.children.isEmpty
          ? Center(
              child: Text(
                txt.tt('error_occurred'), // Or could add a custom 'empty' label
                style: TextStyle(fontSize: baseFontSize),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              itemCount: category.children.length,
              separatorBuilder: (ctx, i) => const SizedBox(height: 12.0),
              itemBuilder: (ctx, i) {
                final subcat = category.children[i];
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
                          builder: (context) => TemplateDecksListScreen(subcategory: subcat),
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
                                  subcat.name,
                                  style: TextStyle(
                                    fontSize: baseFontSize + 2,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(ctx).colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "${txt.tt('decks_count')}: ${subcat.decks.length}",
                                  style: TextStyle(
                                    fontSize: baseFontSize - 1,
                                    color: Theme.of(ctx).colorScheme.onSurfaceVariant,
                                  ),
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
