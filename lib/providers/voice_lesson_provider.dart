import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mindflasher_4/env_config.dart';
import 'package:mindflasher_4/models/user_model.dart';
import 'package:mindflasher_4/translates/voice_lesson_screen_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum VoiceLessonState {
  initial,
  loading,
  playingQuestion,
  waitingForSpeech,
  recordingAnswer,
  uploadingAnswer,
  grading,
  playingFeedback,
  finished,
  error,
}

class VoiceLessonProvider extends ChangeNotifier {
  final int deckId;

  VoiceLessonState _state = VoiceLessonState.initial;
  VoiceLessonState get state => _state;

  int? _currentFlashcardId;
  String? _currentCardQuestion;
  String? get currentCardQuestion => _currentCardQuestion;

  String? _currentCardAnswer;
  String? get currentCardAnswer => _currentCardAnswer;

  String? _currentCardDisplayQuestion;
  String? get currentCardDisplayQuestion => _currentCardDisplayQuestion;

  String? _currentCardDisplayAnswer;
  String? get currentCardDisplayAnswer => _currentCardDisplayAnswer;

  String? _lastTranscript;
  String? get lastTranscript => _lastTranscript;

  String? _feedbackText;
  String? get feedbackText => _feedbackText;

  String? _lastEvaluationResult;
  String? get lastEvaluationResult => _lastEvaluationResult;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  double _amplitude = -160.0;
  double get amplitude => _amplitude;

  bool _isSpeechDetected = false;
  bool _isDisposed = false;

  final AudioPlayer _audioPlayer = AudioPlayer();
  AudioRecorder? _audioRecorder;

  Timer? _thinkingTimer;
  Timer? _silenceTimer;
  StreamSubscription<Amplitude>? _amplitudeSubscription;

  final UserModel userModel;
  final _secureStorage = const FlutterSecureStorage();


  // Timeouts
  static const int thinkingTimeoutSeconds = 15;
  static const int silenceTimeoutMilliseconds = 2500;
  
  double _speechAmplitudeThreshold = -65.0; // dB
  double get speechAmplitudeThreshold => _speechAmplitudeThreshold;

  final String questionLang;
  final String answerLang;

  VoiceLessonProvider(this.deckId, this.userModel, this.questionLang, this.answerLang) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _speechAmplitudeThreshold = prefs.getDouble('speechAmplitudeThreshold') ?? -65.0;
    notifyListeners();
  }

  Future<void> updateSpeechAmplitudeThreshold(double value) async {
    _speechAmplitudeThreshold = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('speechAmplitudeThreshold', value);
  }

  Future<void> startLesson() async {
    await _initSession();
  }

  void _setState(VoiceLessonState newState) {
    _state = newState;
    print('[VoiceLessonProvider] State changed to: ${newState.name}');
    notifyListeners();
  }

  Future<void> _initSession() async {
    print('[VoiceLessonProvider] Initializing session for Deck: $deckId');
    _setState(VoiceLessonState.loading);

    try {
      final token = userModel.token ?? '';
      final response = await http.post(
        Uri.parse('${EnvConfig.mainApiUrl}/api/voice-lessons/start'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'deck_id': deckId}),
      );

      print('[VoiceLessonProvider] Start response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'completed' || data['next_card'] == null) {
          _setState(VoiceLessonState.finished);
          return;
        }

        _handleNextCard(data['next_card']);
      } else {
        _errorMessage = 'Failed to start lesson. Status: ${response.statusCode}';
        _setState(VoiceLessonState.error);
      }
    } catch (e) {
      print('[VoiceLessonProvider] Error starting session: $e');
      _errorMessage = e.toString();
      _setState(VoiceLessonState.error);
    }
  }

  Future<void> _handleNextCard(Map<String, dynamic> card) async {
    _currentFlashcardId = card['id'];
    _currentCardQuestion = card['question'];
    _currentCardAnswer = card['answer'];
    _currentCardDisplayQuestion = card['display_question'] ?? _currentCardQuestion;
    _currentCardDisplayAnswer = card['display_answer'] ?? _currentCardAnswer;
    _feedbackText = null;
    _lastEvaluationResult = null;
    _lastTranscript = null;

    print('[VoiceLessonProvider] Next card loaded: $_currentFlashcardId');

    await _playQuestionAudio();
  }

  Future<void> _playQuestionAudio() async {
    _setState(VoiceLessonState.playingQuestion);
    
    final token = userModel.token ?? '';
    final encodedToken = Uri.encodeComponent(token);
    final encodedText = Uri.encodeComponent(_currentCardQuestion ?? '');
    // Using direct audio stream endpoint with the correct question language
    final audioUrl = '${EnvConfig.mainApiUrl}/api/flashcards/$_currentFlashcardId/audio/direct?lang=$questionLang&token=$encodedToken&text=$encodedText';

    print('[VoiceLessonProvider] Playing question audio: $audioUrl');

    try {
      await _audioPlayer.setUrl(audioUrl);
      await _audioPlayer.play();
      await _audioPlayer.playerStateStream.firstWhere((state) => state.processingState == ProcessingState.completed);
      print('[VoiceLessonProvider] Question audio finished.');
    } catch (e) {
      print('[VoiceLessonProvider] Error playing question audio: $e');
      // If audio fails, we still proceed to recording
    }

    // Play beep
    // NOTE: In a real app, load a local asset 'assets/sounds/beep.mp3'
    // For now, just wait a bit
    await Future.delayed(const Duration(milliseconds: 500));

    _startListening();
  }

  Future<void> _startListening() async {
    print('[VoiceLessonProvider] Checking microphone permission...');
    
    // Dispose previous recorder and create a new one to prevent Web state issues
    _audioRecorder?.dispose();
    _audioRecorder = AudioRecorder();

    if (await _audioRecorder!.hasPermission()) {
      _setState(VoiceLessonState.waitingForSpeech);
      _isSpeechDetected = false;

      String path = '';
      if (!kIsWeb) {
        final dir = await getTemporaryDirectory();
        path = '${dir.path}/answer_$_currentFlashcardId.m4a';
      }

      final encoder = kIsWeb ? AudioEncoder.opus : AudioEncoder.aacLc;
      
      await _audioRecorder!.start(
        RecordConfig(encoder: encoder, bitRate: 64000),
        path: kIsWeb ? '' : path,
      );

      _amplitudeSubscription = _audioRecorder!.onAmplitudeChanged(const Duration(milliseconds: 100)).listen((amp) {
        _amplitude = amp.current;
        notifyListeners(); // Update UI meter

        if (_amplitude > _speechAmplitudeThreshold) {
          if (!_isSpeechDetected) {
            print('[VoiceLessonProvider] Speech detected! Amplitude: $_amplitude dB');
            _isSpeechDetected = true;
            _setState(VoiceLessonState.recordingAnswer);
            _thinkingTimer?.cancel();
          }

          // Reset silence timer because user is speaking
          _silenceTimer?.cancel();
          _silenceTimer = Timer(const Duration(milliseconds: silenceTimeoutMilliseconds), _onSilenceTimeout);
        }
      });

      // Start thinking timeout
      _thinkingTimer = Timer(const Duration(seconds: thinkingTimeoutSeconds), _onThinkingTimeout);
    } else {
      print('[VoiceLessonProvider] Microphone permission denied.');
      _errorMessage = 'Microphone permission denied.';
      _setState(VoiceLessonState.error);
    }
  }

  void _onThinkingTimeout() {
    print('[VoiceLessonProvider] Thinking timeout reached (User did not speak).');
    _stopRecordingAndProcess(isTimeout: true);
  }

  void _onSilenceTimeout() {
    print('[VoiceLessonProvider] Silence timeout reached (User finished speaking).');
    _stopRecordingAndProcess(isTimeout: false);
  }

  Future<void> _stopRecordingAndProcess({required bool isTimeout}) async {
    _thinkingTimer?.cancel();
    _silenceTimer?.cancel();
    _amplitudeSubscription?.cancel();

    print('[VoiceLessonProvider] Stopping recording...');
    final path = await _audioRecorder?.stop();

    if (isTimeout && !_isSpeechDetected) {
      // User didn't say anything at all.
      print('[VoiceLessonProvider] No speech was detected.');
      final t = VoiceLessonScreenTranslate(questionLang);
      _feedbackText = "${t.tt('feedback_timeout')} The answer was: $_currentCardAnswer";
      
      // Try to play audio for timeout, then show finished
      try {
        final token = userModel.token ?? '';
        final encodedToken = Uri.encodeComponent(token);
        
        // 1. Play timeout phrase
        final timeoutPhrase = Uri.encodeComponent(t.tt('feedback_timeout'));
        final timeoutUrl = '${EnvConfig.mainApiUrl}/api/flashcards/$_currentFlashcardId/audio/direct?lang=$questionLang&token=$encodedToken&text=$timeoutPhrase';
        await _audioPlayer.setUrl(timeoutUrl);
        await _audioPlayer.play();
        await _audioPlayer.playerStateStream.firstWhere((state) => state.processingState == ProcessingState.completed);

        await Future.delayed(const Duration(milliseconds: 300));

        // 2. Play the correct answer
        final answerPhrase = Uri.encodeComponent(_currentCardAnswer ?? '');
        final answerUrl = '${EnvConfig.mainApiUrl}/api/flashcards/$_currentFlashcardId/audio/direct?lang=$answerLang&token=$encodedToken&text=$answerPhrase';
        await _audioPlayer.setUrl(answerUrl);
        await _audioPlayer.play();
        await _audioPlayer.playerStateStream.firstWhere((state) => state.processingState == ProcessingState.completed);
      } catch(e) {
        print('Error playing timeout audio: $e');
      }

      _setState(VoiceLessonState.finished);
    } else if (path != null) {
      await _uploadAnswer(path, isEmpty: false);
    } else {
      print('[VoiceLessonProvider] Error: Recording path is null');
      _errorMessage = 'Failed to save recording.';
      _setState(VoiceLessonState.error);
    }
  }

  Future<void> skipCardDontKnow() async {
    if (_state == VoiceLessonState.recordingAnswer || _state == VoiceLessonState.waitingForSpeech) {
      print('[VoiceLessonProvider] User clicked I dont know. Skipping transcription...');
      await _audioRecorder?.stop();
      _thinkingTimer?.cancel();
      _silenceTimer?.cancel();
      _amplitudeSubscription?.cancel();
      _isSpeechDetected = false;
      await _uploadAnswer(null, isEmpty: true);
    }
  }

  Future<void> _uploadAnswer(String? filePath, {required bool isEmpty}) async {
    _setState(VoiceLessonState.uploadingAnswer);
    print('[VoiceLessonProvider] Uploading answer...');

    try {
      final token = userModel.token ?? '';
      var request = http.MultipartRequest('POST', Uri.parse('${EnvConfig.mainApiUrl}/api/voice-lessons/answer'));
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';
      
      request.fields['deck_id'] = deckId.toString();
      request.fields['flashcard_id'] = _currentFlashcardId.toString();
      request.fields['language'] = answerLang; // Use the deck's answer language
      
      if (isEmpty) {
        request.fields['is_timeout'] = '1';
      }

      if (!isEmpty && filePath != null) {
        if (kIsWeb) {
          // On Web, the path is a blob URL. We need to fetch the bytes.
          final blobResponse = await http.get(Uri.parse(filePath));
          request.files.add(http.MultipartFile.fromBytes(
            'audio', 
            blobResponse.bodyBytes, 
            filename: 'answer.webm',
          ));
        } else {
          request.files.add(await http.MultipartFile.fromPath('audio', filePath));
        }
        print('[VoiceLessonProvider] Audio file attached.');
      } else {
        print('[VoiceLessonProvider] Skipping audio upload (sending empty).');
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('[VoiceLessonProvider] Upload response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        _setState(VoiceLessonState.grading);
        final data = jsonDecode(response.body);

        final evaluation = data['evaluation'];
        if (evaluation != null) {
           _feedbackText = "You said: '${data['transcript']}'.\nResult: ${evaluation['result']}\nCorrect: ${data['correct_answer']}";
           print('[VoiceLessonProvider] Evaluation: $_feedbackText');
        }

        _setState(VoiceLessonState.playingFeedback);
        
        try {
          final t = VoiceLessonScreenTranslate(questionLang);
          final token = userModel.token ?? '';
          final encodedToken = Uri.encodeComponent(token);

          if (evaluation != null) {
            _lastTranscript = data['transcript'];
            _currentCardDisplayAnswer = data['display_correct_answer'] ?? _currentCardDisplayAnswer;
            
            final result = evaluation['result'];
            _lastEvaluationResult = result;
            String feedbackKey = 'feedback_red';
            if (result == 'green') feedbackKey = 'feedback_green';
            if (result == 'yellow') feedbackKey = 'feedback_yellow';
            
            final feedbackPhrase = t.tt(feedbackKey);
            
            // 1. Play template phrase
            final encodedFeedback = Uri.encodeComponent(feedbackPhrase);
            final feedbackUrl = '${EnvConfig.mainApiUrl}/api/flashcards/$_currentFlashcardId/audio/direct?lang=$questionLang&token=$encodedToken&text=$encodedFeedback';
            if (_isDisposed) return;
            await _audioPlayer.setUrl(feedbackUrl);
            await _audioPlayer.play();
            if (_isDisposed) return;
            await _audioPlayer.playerStateStream.firstWhere((state) => state.processingState == ProcessingState.completed);
            
            await Future.delayed(const Duration(milliseconds: 300));
            if (_isDisposed) return;

            // 2. Play correct answer
            final correctAnswerText = data['correct_answer'] ?? _currentCardAnswer ?? '';
            final encodedAnswer = Uri.encodeComponent(correctAnswerText);
            final answerUrl = '${EnvConfig.mainApiUrl}/api/flashcards/$_currentFlashcardId/audio/direct?lang=$answerLang&token=$encodedToken&text=$encodedAnswer';
            
            await _audioPlayer.setSpeed(1.0);
            await _audioPlayer.setUrl(answerUrl);
            await _audioPlayer.play();
            if (_isDisposed) return;
            await _audioPlayer.playerStateStream.firstWhere((state) => state.processingState == ProcessingState.completed);

            if (result == 'yellow' || result == 'red') {
              await Future.delayed(const Duration(milliseconds: 300));
              if (_isDisposed) return;
              await _audioPlayer.setSpeed(0.5);
              await _audioPlayer.setUrl(answerUrl);
              await _audioPlayer.play();
              if (_isDisposed) return;
              await _audioPlayer.playerStateStream.firstWhere((state) => state.processingState == ProcessingState.completed);
              await _audioPlayer.setSpeed(1.0); // Restore normal speed for next card
            }

            await Future.delayed(const Duration(milliseconds: 500));
            if (_isDisposed) return;
          } else {
            // It was a command like skip or don't know
            await Future.delayed(const Duration(seconds: 2));
          }
        } catch (e) {
          print('[VoiceLessonProvider] Error playing feedback audio: $e');
          await Future.delayed(const Duration(seconds: 2));
        }

        if (data['is_finished'] == true || data['next_card'] == null) {
          _setState(VoiceLessonState.finished);
        } else {
          _handleNextCard(data['next_card']);
        }
      } else {
        _errorMessage = 'Upload failed: ${response.statusCode}';
        _setState(VoiceLessonState.error);
      }

    } catch (e) {
      print('[VoiceLessonProvider] Upload error: $e');
      _errorMessage = 'Network error during upload.';
      _setState(VoiceLessonState.error);
    }
  }

  void cancelSession() {
    print('[VoiceLessonProvider] Cancelling session...');
    _thinkingTimer?.cancel();
    _silenceTimer?.cancel();
    _amplitudeSubscription?.cancel();
    _audioRecorder?.stop();
    try {
      _audioPlayer.stop();
    } catch (e) {
      print('[VoiceLessonProvider] Error stopping audio player: $e');
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    cancelSession();
    _audioRecorder?.dispose();
    try {
      _audioPlayer.dispose();
    } catch (e) {
      print('[VoiceLessonProvider] Error disposing audio player: $e');
    }
    super.dispose();
  }
}
