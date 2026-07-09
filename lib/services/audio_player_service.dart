import 'package:just_audio/just_audio.dart';
import 'package:mindflasher_4/services/app_http_client.dart';

class AudioPlayerService {
  AudioPlayer? _player;
  final AppHttpClient _httpClient;
  final String _baseUrl;
  final String? _bearerToken;

  AudioPlayerService(this._httpClient, this._baseUrl, this._bearerToken);

  static int _cacheBuster = 0;

  /// Fetches the audio URL from the backend and plays it.
  Future<void> playFlashcardAudio(int flashcardId, String lang, {String? text, double speed = 1.0, String? voiceId}) async {
    // Lazy initialization to ensure AudioContext is created synchronously with the user gesture.
    _player ??= AudioPlayer();

    // To prevent iOS Safari autoplay restrictions, we must start playing immediately.
    // We construct a direct streaming URL that the browser's <audio> tag will fetch.
    // The backend will handle the delay of generating the file and then stream it.
    
    String fullUrl = '$_baseUrl/api/flashcards/$flashcardId/audio/direct?lang=$lang';
    if (_bearerToken != null && _bearerToken.isNotEmpty) {
      final encodedToken = Uri.encodeComponent(_bearerToken);
      fullUrl += '&token=$encodedToken';
    }
    if (text != null && text.isNotEmpty) {
      final encodedText = Uri.encodeComponent(text);
      fullUrl += '&text=$encodedText';
    }
    if (voiceId != null && voiceId.isNotEmpty) {
      final encodedVoiceId = Uri.encodeComponent(voiceId);
      fullUrl += '&voice_id=$encodedVoiceId';
    }
    
    // Add cache buster to force the browser/player to fetch a fresh file if cache was cleared
    fullUrl += '&cb=$_cacheBuster';

    try {
      await _player!.setSpeed(speed);
      // Adding a 15-second timeout. If the server doesn't respond or returns a 404 that hangs the player, this will throw and stop the spinner.
      await _player!.setUrl(fullUrl).timeout(const Duration(seconds: 15));
      await _player!.play();
    } catch (e) {
      throw Exception('Failed to play audio stream: $e');
    }
  }

  Future<void> clearFlashcardAudioCache(int flashcardId, String lang) async {
    String fullUrl = '$_baseUrl/api/flashcards/$flashcardId/audio/cache?lang=$lang';
    final Map<String, String> headers = {};
    if (_bearerToken != null && _bearerToken.isNotEmpty) {
      headers['Authorization'] = 'Bearer $_bearerToken';
    }

    final response = await _httpClient.delete(Uri.parse(fullUrl), headers: headers);
    if (response.statusCode != 200) {
      throw Exception('Failed to clear audio cache: ${response.statusCode}');
    }
    
    // Increment cache buster to force fresh fetch on next play
    _cacheBuster++;
  }

  void dispose() {
    _player?.dispose();
  }
}
