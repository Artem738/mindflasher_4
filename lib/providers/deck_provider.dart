import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mindflasher_4/env_config.dart';
import 'package:mindflasher_4/models/deck_model.dart';
import 'package:mindflasher_4/models/user_model.dart';
import 'package:mindflasher_4/services/app_http_client.dart';

class DeckProvider extends ChangeNotifier {
  DeckProvider(UserModel userModel, {AppHttpClient? httpClient})
      : _userModel = userModel,
        _httpClient = httpClient ?? AppHttpClient();

  UserModel _userModel;
  final AppHttpClient _httpClient;
  final List<DeckModel> _decks = [];

  List<DeckModel> get decks => _decks;

  void updateUserModel(UserModel userModel) {
    _userModel = userModel;
  }

  String _token() => _userModel.requireToken();

  Map<String, String> _headers() {
    return _httpClient.jsonHeaders(
      bearerToken: _token(),
      extraHeaders: const {'Accept': 'application/json'},
    );
  }

  // Метод для создания новой колоды
  Future<bool> createDeck(String name, String description, {int? templateDeckId, String? questionLang, String? answerLang}) async {
    final apiUrl = '${EnvConfig.mainApiUrl}/api/decks';
    final response = await _httpClient.post(
      Uri.parse(apiUrl),
      headers: _headers(),
      body: jsonEncode({
        'name': name,
        'description': description,
        if (templateDeckId != null) 'template_deck_id': templateDeckId,
        if (questionLang != null && questionLang.isNotEmpty) 'question_lang': questionLang,
        if (answerLang != null && answerLang.isNotEmpty) 'answer_lang': answerLang,
      }),
    );

    if (response.statusCode == 201) {
      await fetchDecks();
      return true;
    }

    return false;
  }

  // Метод для обновления существующей колоды
  Future<bool> updateDeck(int deckId, String name, String description, {String? questionLang, String? answerLang}) async {
    final apiUrl = '${EnvConfig.mainApiUrl}/api/decks/$deckId';
    final response = await _httpClient.put(
      Uri.parse(apiUrl),
      headers: _headers(),
      body: jsonEncode({
        'name': name,
        'description': description,
        if (questionLang != null && questionLang.isNotEmpty) 'question_lang': questionLang,
        if (answerLang != null && answerLang.isNotEmpty) 'answer_lang': answerLang,
      }),
    );

    if (response.statusCode == 200) {
      await fetchDecks();
      return true;
    }

    return false;
  }

  // Метод для получения одной колоды по ID
  Future<DeckModel?> getDeck(int deckId) async {
    final apiUrl = '${EnvConfig.mainApiUrl}/api/decks/$deckId';
    final response = await _httpClient.get(
      Uri.parse(apiUrl),
      headers: _headers(),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return DeckModel.fromJson(data);
    }

    return null;
  }

  // Метод для удаления колоды пользователя
  Future<bool> deleteDeck(int deckId) async {
    final apiUrl = '${EnvConfig.mainApiUrl}/api/decks/$deckId';
    final response = await _httpClient.delete(
      Uri.parse(apiUrl),
      headers: _headers(),
    );

    if (response.statusCode == 200) {
      await fetchDecks();
      return true;
    }

    return false;
  }

  // Метод для получения всех колод пользователя
  Future<void> fetchDecks() async {
    final apiUrl = '${EnvConfig.mainApiUrl}/api/decks';
    final response = await _httpClient.get(
      Uri.parse(apiUrl),
      headers: _headers(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      _decks.clear();

      _decks.addAll(data.map((item) => DeckModel.fromJson(item)));
      notifyListeners();
    } else {
      throw AppHttpException('Failed to load decks', statusCode: response.statusCode);
    }
  }
}
