import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mindflasher_4/providers/voice_lesson_provider.dart';
import 'package:mindflasher_4/providers/provider_user_control.dart';
import 'package:mindflasher_4/providers/provider_user_login.dart';
import 'package:mindflasher_4/models/user_model.dart';
import 'package:mindflasher_4/translates/voice_lesson_screen_translate.dart';
import 'package:flutter/services.dart';

class VoiceLessonScreen extends StatelessWidget {
  final int deckId;
  final String deckName;
  final String questionLang;
  final String answerLang;

  const VoiceLessonScreen({
    super.key,
    required this.deckId,
    required this.deckName,
    required this.questionLang,
    required this.answerLang,
  });

  @override
  Widget build(BuildContext context) {
    final userModel = context.watch<UserModel>();
    return ChangeNotifierProvider(
      create: (_) => VoiceLessonProvider(deckId, userModel, questionLang, answerLang),
      child: _VoiceLessonScreenBody(deckName: deckName),
    );
  }
}

class _VoiceLessonScreenBody extends StatelessWidget {
  final String deckName;

  const _VoiceLessonScreenBody({required this.deckName});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VoiceLessonProvider>();
    final userModel = context.watch<UserModel>();
    final txt = VoiceLessonScreenTranslate(userModel.language_code ?? 'en');

    return Scaffold(
      appBar: AppBar(
        title: Text(txt.tt('title')),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                deckName,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              if (provider.state == VoiceLessonState.initial) ...[
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        if (context.read<ProviderUserLogin>().isTelegramFeatureWorks)
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.1),
                              border: Border.all(color: Colors.orange),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.warning_amber_rounded, color: Colors.orange),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        txt.tt('telegram_warning'),
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                OutlinedButton.icon(
                                  onPressed: () async {
                                    try {
                                      final link = await context.read<ProviderUserControl>().generateWebLink();
                                      await Clipboard.setData(ClipboardData(text: link));
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text(txt.tt('link_copied'))),
                                        );
                                      }
                                    } catch (e) {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text(e.toString())),
                                        );
                                      }
                                    }
                                  },
                                  icon: const Icon(Icons.copy, size: 18),
                                  label: Text(txt.tt('copy_web_link')),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.orange,
                                    side: const BorderSide(color: Colors.orange),
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              border: Border.all(color: Colors.green),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(Icons.check_circle_outline, color: Colors.green, size: 28),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    txt.tt('browser_success'),
                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.green),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 32),
                        const Icon(Icons.record_voice_over, size: 64, color: Colors.blueGrey),
                        const SizedBox(height: 24),
                        Text(
                          txt.tt('initial_title'),
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          txt.tt('initial_desc'),
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          '${txt.tt('sensitivity_title')}: ${provider.speechAmplitudeThreshold.toStringAsFixed(1)} dB',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          txt.tt('sensitivity_desc'),
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                txt.tt('sensitivity_quiet'),
                                textAlign: TextAlign.right,
                                style: const TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Slider(
                                value: provider.speechAmplitudeThreshold.clamp(-60.0, -30.0),
                                min: -60.0,
                                max: -30.0,
                                divisions: 30,
                                activeColor: Colors.orange,
                                label: '${provider.speechAmplitudeThreshold.toStringAsFixed(1)} dB',
                                onChanged: (value) {
                                  provider.updateSpeechAmplitudeThreshold(value);
                                },
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                txt.tt('sensitivity_noisy'),
                                textAlign: TextAlign.left,
                                style: const TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    provider.startLesson();
                  },
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Start Lesson', style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                ),
              ] else ...[
                _buildStateIcon(context, provider),
                const SizedBox(height: 16),
                Text(
                  _getStateText(txt, provider.state),
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                if (provider.currentCardDisplayQuestion != null)
                  Text(
                    provider.currentCardDisplayQuestion!,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                if (provider.state == VoiceLessonState.playingFeedback && provider.currentCardDisplayAnswer != null) ...[
                  const SizedBox(height: 24),
                  Text(
                    provider.currentCardDisplayAnswer!,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: _getResultColor(provider.lastEvaluationResult),
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
                if (provider.state == VoiceLessonState.playingFeedback && provider.lastTranscript != null) ...[
                  const SizedBox(height: 24),
                  Text(
                    "You said: '${provider.lastTranscript}'",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontStyle: FontStyle.italic,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
                if (provider.errorMessage != null) ...[
                  const SizedBox(height: 24),
                  Text(
                    provider.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ],
                const Spacer(),
                if (provider.state == VoiceLessonState.recordingAnswer || provider.state == VoiceLessonState.waitingForSpeech) ...[
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        provider.skipCardDontKnow();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(txt.tt('dont_know'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildAmplitudeMeter(context, provider.amplitude),
                ],
                const SizedBox(height: 24),
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.stop),
                  label: Text(txt.tt('close')),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getResultColor(String? result) {
    if (result == 'green') return Colors.green;
    if (result == 'yellow') return Colors.orange;
    if (result == 'red') return Colors.red;
    return Colors.grey;
  }

  Widget _buildStateIcon(BuildContext context, VoiceLessonProvider provider) {
    IconData iconData;
    Color color = Theme.of(context).colorScheme.primary;
    bool isPulsing = false;

    switch (provider.state) {
      case VoiceLessonState.initial:
        iconData = Icons.play_circle_fill;
        break;
      case VoiceLessonState.loading:
        return const CircularProgressIndicator();
      case VoiceLessonState.playingQuestion:
        iconData = Icons.volume_up;
        break;
      case VoiceLessonState.waitingForSpeech:
        iconData = Icons.mic_none;
        color = Colors.orange;
        break;
      case VoiceLessonState.recordingAnswer:
        iconData = Icons.mic;
        color = Colors.red;
        isPulsing = true;
        break;
      case VoiceLessonState.uploadingAnswer:
      case VoiceLessonState.grading:
        iconData = Icons.cloud_upload;
        color = Colors.blue;
        break;
      case VoiceLessonState.playingFeedback:
        iconData = Icons.check_circle_outline;
        color = _getResultColor(provider.lastEvaluationResult);
        if (provider.lastEvaluationResult == 'red') {
          iconData = Icons.cancel_outlined;
        }
        break;
      case VoiceLessonState.finished:
        iconData = Icons.flag;
        color = Colors.green;
        break;
      case VoiceLessonState.error:
        iconData = Icons.error_outline;
        color = Colors.red;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.1),
        border: Border.all(color: color, width: isPulsing ? 4 : 2),
      ),
      child: Icon(iconData, size: 48, color: color),
    );
  }

  String _getStateText(VoiceLessonScreenTranslate txt, VoiceLessonState state) {
    switch (state) {
      case VoiceLessonState.initial: return '';
      case VoiceLessonState.loading: return txt.tt('state_loading');
      case VoiceLessonState.playingQuestion: return txt.tt('state_playing_question');
      case VoiceLessonState.waitingForSpeech: return txt.tt('state_waiting_speech');
      case VoiceLessonState.recordingAnswer: return txt.tt('state_recording');
      case VoiceLessonState.uploadingAnswer: return txt.tt('state_uploading');
      case VoiceLessonState.grading: return txt.tt('state_grading');
      case VoiceLessonState.playingFeedback: return txt.tt('state_playing_feedback');
      case VoiceLessonState.finished: return txt.tt('state_finished');
      case VoiceLessonState.error: return 'Error';
    }
  }

  Widget _buildAmplitudeMeter(BuildContext context, double amplitude) {
    // Amplitude is typically -160 (silent) to 0 (loudest)
    // Normalize to 0.0 - 1.0
    double normalized = (amplitude + 60) / 60; // Just a rough scale for visual
    normalized = normalized.clamp(0.0, 1.0);

    return Column(
      children: [
        const Text("Mic Level"),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: normalized,
          backgroundColor: Colors.grey.withOpacity(0.2),
          color: normalized > 0.5 ? Colors.green : Colors.orange,
        ),
      ],
    );
  }
}
