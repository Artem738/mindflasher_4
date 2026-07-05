import 'dart:convert';
import 'package:just_audio/just_audio.dart';
import 'package:mindflasher_4/services/app_http_client.dart';

class AudioPlayerService {
  AudioPlayer? _player;
  final AppHttpClient _httpClient;
  final String _baseUrl;
  final String? _bearerToken;

  AudioPlayerService(this._httpClient, this._baseUrl, this._bearerToken);

  /// Fetches the audio URL from the backend and plays it.
  Future<void> playFlashcardAudio(int flashcardId, String lang) async {
    // Lazy initialization to ensure AudioContext is created synchronously with the user gesture.
    _player ??= AudioPlayer();

    // To prevent iOS Safari autoplay restrictions, we must start playing immediately.
    // We construct a direct streaming URL that the browser's <audio> tag will fetch.
    // The backend will handle the delay of generating the file and then stream it.
    
    String fullUrl = '$_baseUrl/api/flashcards/$flashcardId/audio/direct?lang=$lang';
    if (_bearerToken != null && _bearerToken!.isNotEmpty) {
      final encodedToken = Uri.encodeComponent(_bearerToken!);
      fullUrl += '&token=$encodedToken';
    }

    try {
      // Adding a 15-second timeout. If the server doesn't respond or returns a 404 that hangs the player, this will throw and stop the spinner.
      await _player!.setUrl(fullUrl).timeout(const Duration(seconds: 15));
      await _player!.play();
    } catch (e) {
      throw Exception('Failed to play audio stream: $e');
    }
  }

  void dispose() {
    _player?.dispose();
  }
}
