import 'package:flutter/material.dart';
import 'package:mindflasher_4/models/deck_model.dart';
import 'package:mindflasher_4/models/flashcard_model.dart';
import 'package:mindflasher_4/providers/flashcard_provider.dart';
import 'package:mindflasher_4/providers/provider_user_control.dart';
import 'package:mindflasher_4/tech_data/weight_delays_enum.dart';
import 'package:mindflasher_4/translates/flashcard_study_screen_translate.dart';
import 'package:mindflasher_4/screens/flashcard_management_screen.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:provider/provider.dart';
import 'package:mindflasher_4/services/audio_player_service.dart';
import 'package:mindflasher_4/services/app_http_client.dart';
import 'package:mindflasher_4/env_config.dart';

class FlashcardStudyScreen extends StatefulWidget {
  final FlashcardModel flashcard;
  final DeckModel deck;
  final bool startAnswerRevealed;

  const FlashcardStudyScreen({
    super.key,
    required this.flashcard,
    required this.deck,
    this.startAnswerRevealed = false,
  });

  @override
  State<FlashcardStudyScreen> createState() => _FlashcardStudyScreenState();
}

class _FlashcardStudyScreenState extends State<FlashcardStudyScreen> {
  late bool _showAnswer;
  AudioPlayerService? _audioPlayerService;
  bool _isAudioLoading = false;

  String? _lastPlayedText;
  bool _isSlowMode = false;

  @override
  void initState() {
    super.initState();
    _showAnswer = widget.startAnswerRevealed;
  }

  @override
  void dispose() {
    _audioPlayerService?.dispose();
    super.dispose();
  }

  Future<void> _playAudio(String userLanguage, {String? textToPlay, double speed = 1.0}) async {
    if (_audioPlayerService == null) {
      final userModel = context.read<ProviderUserControl>().userModel;
      _audioPlayerService = AudioPlayerService(
        AppHttpClient(),
        EnvConfig.mainApiUrl,
        userModel.token,
      );
    }

    setState(() {
      _isAudioLoading = true;
    });

    try {
      await _audioPlayerService!.playFlashcardAudio(widget.flashcard.id, userLanguage, text: textToPlay, speed: speed);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error playing audio: $e')),
        );
      }
    } finally {
      if (context.mounted) {
        setState(() {
          _isAudioLoading = false;
        });
      }
    }
  }

  Future<void> _clearAudioCache(String userLanguage) async {
    if (_audioPlayerService == null) {
      final userModel = context.read<ProviderUserControl>().userModel;
      _audioPlayerService = AudioPlayerService(
        AppHttpClient(),
        EnvConfig.mainApiUrl,
        userModel.token,
      );
    }

    try {
      await _audioPlayerService!.clearFlashcardAudioCache(widget.flashcard.id, userLanguage);
      if (context.mounted) {
        final txt = FlashcardStudyScreenTranslate(userLanguage);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(txt.tt('audio_cache_cleared'))),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error clearing cache: $e')),
        );
      }
    }
  }

  void _gradeCard(WeightDelaysEnum grade) {
    Provider.of<FlashcardProvider>(context, listen: false).updateCardWeight(
      widget.deck,
      widget.flashcard.id,
      grade,
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final baseFontSize =
        context.watch<ProviderUserControl>().userModel.base_font_size;
    final userLanguage =
        context.watch<ProviderUserControl>().userModel.language_code ?? 'en';
    final txt = FlashcardStudyScreenTranslate(userLanguage);
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Build markdown configurations aligned with the current baseFontSize
    final baseMarkdownConfig =
        isDark ? MarkdownConfig.darkConfig : MarkdownConfig.defaultConfig;
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
        LinkConfig(
          style: TextStyle(
            color: colorScheme.primary,
            decoration: TextDecoration.underline,
          ),
          onTap: (url) {
            if (url.startsWith('tts://')) {
              final textToPlay = Uri.decodeComponent(url.replaceFirst('tts://', ''));
              
              if (_lastPlayedText == textToPlay) {
                _isSlowMode = !_isSlowMode;
              } else {
                _lastPlayedText = textToPlay;
                _isSlowMode = false;
              }

              _playAudio(
                userLanguage, 
                textToPlay: textToPlay,
                speed: _isSlowMode ? 0.5 : 1.0,
              );
            }
          },
        ),
      ],
    );

    final String displayAnswer = widget.flashcard.answer
        .replaceAllMapped(RegExp(r'\[v\](.*?)\[/v\]'), (match) {
          final word = match.group(1);
          final encodedWord = Uri.encodeComponent(word ?? '');
          return '[$word 🔊](tts://$encodedWord)';
        })
        .replaceAll('\\n', '\n');

    return Scaffold(
      appBar: AppBar(
        title: Text(txt.tt('study_title')),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => FlashcardManagementScreen(
                    deck: widget.deck,
                    flashcard: widget.flashcard,
                  ),
                ),
              );
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Question Card
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      color: colorScheme.surfaceContainerLow,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              txt.tt('question'),
                              style: TextStyle(
                                fontSize: baseFontSize * 0.85,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.primary,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 12),
                            MarkdownBlock(
                              data: widget.flashcard.question,
                              config: markdownConfig,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Show Answer Button
                    if (!_showAnswer)
                      Center(
                        child: FilledButton.icon(
                          onPressed: () {
                            setState(() {
                              _showAnswer = true;
                            });
                          },
                          icon: const Icon(Icons.wb_incandescent_outlined),
                          label: Text(
                            txt.tt('show_answer'),
                            style: TextStyle(
                              fontSize: baseFontSize * 1.1,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                          style: FilledButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32.0,
                              vertical: 16.0,
                            ),
                            elevation: 2,
                          ),
                        ),
                      ),

                    // Answer Section (Faded in when revealed)
                    if (_showAnswer)
                      AnimatedOpacity(
                        opacity: _showAnswer ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        child: GestureDetector(
                          onLongPress: () => _clearAudioCache(userLanguage),
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            color: colorScheme.secondaryContainer.withOpacity(0.4),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      txt.tt('answer'),
                                      style: TextStyle(
                                        fontSize: baseFontSize * 0.85,
                                        fontWeight: FontWeight.bold,
                                        color: colorScheme.secondary,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                    if (_isAudioLoading)
                                      SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: colorScheme.primary,
                                        ),
                                      )
                                    else
                                      const SizedBox(width: 20, height: 20), // Prevent layout shift
                                  ],
                                ),
                                const SizedBox(height: 12),
                                MarkdownBlock(
                                  data: displayAnswer,
                                  config: markdownConfig,
                                ),
                              ],
                            ),
                          ),
                        ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Grade Action Buttons at Bottom
            if (_showAnswer)
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      // Red Button
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: ElevatedButton.icon(
                            onPressed: () => _gradeCard(WeightDelaysEnum.badSmallDelay),
                            icon: const Icon(Icons.history),
                            label: Text(
                              txt.tt('grade_bad'),
                              style: TextStyle(
                                fontSize: (baseFontSize * 0.85).clamp(10, 16),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              foregroundColor: Colors.white,
                              elevation: 2,
                              padding: const EdgeInsets.symmetric(vertical: 12.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Yellow Button
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: ElevatedButton.icon(
                            onPressed: () => _gradeCard(WeightDelaysEnum.normMedDelay),
                            icon: const Icon(Icons.schedule),
                            label: Text(
                              txt.tt('grade_medium'),
                              style: TextStyle(
                                fontSize: (baseFontSize * 0.85).clamp(10, 16),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber,
                              foregroundColor: Colors.black87,
                              elevation: 2,
                              padding: const EdgeInsets.symmetric(vertical: 12.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Green Button
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: ElevatedButton.icon(
                            onPressed: () => _gradeCard(WeightDelaysEnum.goodLongDelay),
                            icon: const Icon(Icons.check_circle_outline),
                            label: Text(
                              txt.tt('grade_good'),
                              style: TextStyle(
                                fontSize: (baseFontSize * 0.85).clamp(10, 16),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              elevation: 2,
                              padding: const EdgeInsets.symmetric(vertical: 12.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
