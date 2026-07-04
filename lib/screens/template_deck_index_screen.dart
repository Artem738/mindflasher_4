import 'package:flutter/material.dart';
import 'package:mindflasher_4/providers/template_deck_provider.dart';
import 'package:mindflasher_4/providers/provider_user_control.dart';
import 'package:mindflasher_4/screens/template_subcategory_screen.dart';
import 'package:mindflasher_4/screens/template_flashcard_index_screen.dart';
import 'package:mindflasher_4/screens/deck/deck_management_screen.dart';
import 'package:mindflasher_4/translates/template_deck_index_screen_translate.dart';
import 'package:mindflasher_4/models/template_deck_model.dart';
import 'package:provider/provider.dart';

class TemplateDeckIndexScreen extends StatefulWidget {
  const TemplateDeckIndexScreen({super.key});

  @override
  State<TemplateDeckIndexScreen> createState() => _TemplateDeckIndexScreenState();
}

class _TemplateDeckIndexScreenState extends State<TemplateDeckIndexScreen> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  late Future<void> _fetchDecksFuture;

  @override
  void initState() {
    super.initState();
    _fetchDecksFuture = context.read<TemplateDeckProvider>().fetchDecks();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseFontSize = context.read<ProviderUserControl>().userModel.base_font_size;
    final userLang = context.read<ProviderUserControl>().userModel.language_code ?? 'ru';
    var txt = TemplateDeckIndexScreenTranslate(userLang);

    return Scaffold(
      appBar: AppBar(
        title: Text(txt.tt('template_decks')),
      ),
      body: FutureBuilder(
        future: _fetchDecksFuture,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("${txt.tt('error_occurred')}: ${snapshot.error}"));
          } else {
            return Consumer<TemplateDeckProvider>(
              builder: (ctx, deckProvider, child) {
                // Категории уже отфильтрованы по языку пользователя на бэкенде
                final categories = deckProvider.categories;

                // Если есть поиск, ищем по всем вложенным колодам
                final List<TemplateDeckModel> matchingDecks = [];
                if (_searchQuery.isNotEmpty) {
                  final query = _searchQuery.toLowerCase();
                  for (var cat in categories) {
                    for (var subcat in cat.children) {
                      for (var deck in subcat.decks) {
                        if (deck.name.toLowerCase().contains(query) ||
                            deck.description.toLowerCase().contains(query)) {
                          matchingDecks.add(deck);
                        }
                      }
                    }
                  }
                }

                return Column(
                  children: [
                    // Поле поиска
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 12.0),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (val) {
                          setState(() {
                            _searchQuery = val;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: txt.tt('search_hint'),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Theme.of(ctx).colorScheme.primary,
                          ),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {
                                      _searchQuery = '';
                                    });
                                  },
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: Theme.of(ctx).colorScheme.outlineVariant,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                        ),
                      ),
                    ),

                    // Список категорий или результатов поиска
                    Expanded(
                      child: _searchQuery.isEmpty
                          ? categories.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.folder_off_outlined,
                                        size: 64,
                                        color: Theme.of(ctx).colorScheme.onSurfaceVariant.withOpacity(0.4),
                                      ),
                                      const SizedBox(height: 16),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                                        child: Text(
                                          txt.tt('no_templates'),
                                          style: TextStyle(
                                            fontSize: baseFontSize + 1,
                                            color: Theme.of(ctx).colorScheme.onSurfaceVariant,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : ListView.separated(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              itemCount: categories.length,
                              separatorBuilder: (ctx, i) => const SizedBox(height: 12.0),
                              itemBuilder: (ctx, i) {
                                final category = categories[i];
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
                                          builder: (context) => TemplateSubcategoryScreen(category: category),
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
                                                  category.name,
                                                  style: TextStyle(
                                                    fontSize: baseFontSize + 3,
                                                    fontWeight: FontWeight.bold,
                                                    color: Theme.of(ctx).colorScheme.onSurface,
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  "${txt.tt('subcategories')}: ${category.children.length}",
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
                            )
                          : matchingDecks.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.search_off_rounded,
                                        size: 64,
                                        color: Theme.of(ctx).colorScheme.onSurfaceVariant.withOpacity(0.4),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        txt.tt('no_results'),
                                        style: TextStyle(
                                          fontSize: baseFontSize + 1,
                                          color: Theme.of(ctx).colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : ListView.separated(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                  itemCount: matchingDecks.length,
                                  separatorBuilder: (ctx, i) => const SizedBox(height: 12.0),
                                  itemBuilder: (ctx, i) {
                                    final deck = matchingDecks[i];
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
                    ),
                    SafeArea(
                      top: false,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16.0, top: 8.0),
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const DeckManagementScreen(),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Theme.of(context).colorScheme.primary,
                            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.add, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                txt.tt('add_own_deck'),
                                style: TextStyle(
                                  fontSize: baseFontSize.clamp(14.0, 18.0),
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
