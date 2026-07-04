import 'package:flutter/material.dart';
import 'package:mindflasher_4/models/deck_model.dart';
import 'package:mindflasher_4/models/flashcard_model.dart';
import 'package:mindflasher_4/models/user_model.dart';
import 'package:mindflasher_4/providers/flashcard_provider.dart';
import 'package:mindflasher_4/providers/provider_user_login.dart';
import 'package:mindflasher_4/screens/deck/deck_settings_screen.dart';
import 'package:mindflasher_4/screens/flashcard_management_screen.dart';
import 'package:mindflasher_4/translates/flashcard_index_screen_translate.dart';
import 'package:provider/provider.dart';
import 'swipeable_card.dart';

class FlashcardIndexScreen extends StatefulWidget {
  final DeckModel deck;

  const FlashcardIndexScreen({super.key, required this.deck});

  @override
  _FlashcardIndexScreenState createState() => _FlashcardIndexScreenState();
}

class _FlashcardIndexScreenState extends State<FlashcardIndexScreen> {
  late Future<void> _flashcardsFuture;
  String _selectedMode = 'srs';

  @override
  void initState() {
    super.initState();
    _flashcardsFuture = Provider.of<FlashcardProvider>(context, listen: false).fetchAndPopulateFlashcards(widget.deck.id, mode: _selectedMode);
    context.read<ProviderUserLogin>().expandTelegram();
  }

  void _reloadFlashcards() {
    setState(() {
      _flashcardsFuture = Provider.of<FlashcardProvider>(context, listen: false).fetchAndPopulateFlashcards(widget.deck.id, mode: _selectedMode);
    });
  }

  Widget _buildCardItem(BuildContext context, FlashcardModel card, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: SwipeableCard(
        flashcard: card,
        deck: widget.deck,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var txt = FlashcardIndexScreenTranslate(context.read<UserModel>().language_code ?? 'en');

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.deck.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: txt.tt('add_flashcard'),
            onPressed: () {
              Navigator.of(context)
                  .push(
                    MaterialPageRoute(
                      builder: (context) => FlashcardManagementScreen(
                        deck: widget.deck,
                      ),
                    ),
                  )
                  .then(
                    (_) => _reloadFlashcards(),
                  );
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit_note),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DeckSettingsScreen(
                    deck: widget.deck,
                  ),
                ),
              ).then(
                (_) => _reloadFlashcards(),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: SegmentedButton<String>(
              segments: [
                ButtonSegment<String>(
                  value: 'srs',
                  label: Text(txt.tt('study_mode_srs')),
                  icon: const Icon(Icons.school_outlined),
                ),
                ButtonSegment<String>(
                  value: 'all',
                  label: Text(txt.tt('study_mode_all')),
                  icon: const Icon(Icons.menu_book_outlined),
                ),
              ],
              selected: {_selectedMode},
              onSelectionChanged: (Set<String> newSelection) {
                setState(() {
                  _selectedMode = newSelection.first;
                  _flashcardsFuture = Provider.of<FlashcardProvider>(context, listen: false)
                      .fetchAndPopulateFlashcards(widget.deck.id, mode: _selectedMode);
                });
              },
            ),
          ),
          Consumer<FlashcardProvider>(
            builder: (context, provider, child) {
              if (!provider.isOfflineSyncPending) return const SizedBox.shrink();
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                color: Theme.of(context).colorScheme.errorContainer,
                child: Row(
                  children: [
                    Icon(Icons.wifi_off, color: Theme.of(context).colorScheme.onErrorContainer, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        txt.tt('offline_sync_warning'),
                        style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Expanded(
            child: FutureBuilder(
              future: _flashcardsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('An error occurred: ${snapshot.error}'));
                } else {
                  return Consumer<FlashcardProvider>(
                    builder: (context, flashcardProvider, child) {
                      if (flashcardProvider.flashcards.isEmpty) {
                        return SrsCongratsWidget(
                          title: txt.tt('srs_done_title'),
                          subtitle: txt.tt('srs_done_subtitle'),
                          buttonLabel: txt.tt('study_mode_all'),
                          showButton: _selectedMode == 'srs',
                          onButtonPressed: () {
                            setState(() {
                              _selectedMode = 'all';
                              _flashcardsFuture = Provider.of<FlashcardProvider>(context, listen: false)
                                  .fetchAndPopulateFlashcards(widget.deck.id, mode: _selectedMode);
                            });
                          },
                        );
                      }
                      return AnimatedList(
                        key: flashcardProvider.listKey,
                        initialItemCount: flashcardProvider.flashcards.length,
                        itemBuilder: (context, index, animation) {
                          final flashcard = flashcardProvider.flashcards[index];
                          return _buildCardItem(context, flashcard, animation);
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SrsCongratsWidget extends StatefulWidget {
  final String title;
  final String subtitle;
  final String buttonLabel;
  final VoidCallback onButtonPressed;
  final bool showButton;

  const SrsCongratsWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    required this.onButtonPressed,
    this.showButton = true,
  });

  @override
  State<SrsCongratsWidget> createState() => _SrsCongratsWidgetState();
}

class _SrsCongratsWidgetState extends State<SrsCongratsWidget> with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.10).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _pulseAnimation,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorScheme.primaryContainer.withOpacity(0.2),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.primary.withOpacity(0.15),
                        blurRadius: 30,
                        spreadRadius: 10,
                      )
                    ],
                  ),
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Icon(
                      Icons.stars,
                      size: 80,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                widget.title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                widget.subtitle,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.4,
                    ),
                textAlign: TextAlign.center,
              ),
              if (widget.showButton) ...[
                const SizedBox(height: 36),
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: FilledButton.icon(
                    onPressed: widget.onButtonPressed,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 3,
                    ),
                    icon: const Icon(Icons.menu_book_outlined),
                    label: Text(
                      widget.buttonLabel,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
