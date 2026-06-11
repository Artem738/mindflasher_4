import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mindflasher_4/env_config.dart';
import 'package:mindflasher_4/models/flashcard_model.dart';
import 'package:mindflasher_4/models/user_model.dart';
import 'package:mindflasher_4/providers/deck_provider.dart';
import 'package:mindflasher_4/services/app_http_client.dart';
import 'package:provider/provider.dart';

class TemplateFlashcardProvider extends ChangeNotifier {
  TemplateFlashcardProvider(UserModel userModel, {AppHttpClient? httpClient})
      : _userModel = userModel,
        _httpClient = httpClient ?? AppHttpClient();

  UserModel _userModel;
  final AppHttpClient _httpClient;
  final List<FlashcardModel> _templateFlashcards = [];

  List<FlashcardModel> get templateFlashcards => _templateFlashcards;

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


  Future<void> fetchFlashcards(int deckId) async {
    final apiUrl = '${EnvConfig.mainApiUrl}/api/template-decks/$deckId/flashcards';
    final response = await _httpClient.get(
      Uri.parse(apiUrl),
      headers: _headers(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      _templateFlashcards.clear();

      _templateFlashcards.addAll(
        data.map(
          (item) => FlashcardModel(
            id: item['id'],
            deckId: item['deck_id'],
            question: item['question'],
            answer: item['answer'],
            weight: item['weight'],
          ),
        ),
      );
      notifyListeners();
    } else {
      throw AppHttpException('Failed to load template flashcards', statusCode: response.statusCode);
    }
  }

  Future<bool> addTemplateBaseToUser(BuildContext context, int templateDeckId) async {
    final apiUrl = '${EnvConfig.mainApiUrl}/api/add-template-to-user';
    final response = await _httpClient.post(
      Uri.parse(apiUrl),
      headers: _headers(),
      body: jsonEncode({
        'template_deck_id': templateDeckId,
      }),
    );

    if (response.statusCode == 200) {
      await Provider.of<DeckProvider>(context, listen: false).fetchDecks();
      notifyListeners();
      return true;
    }

    return false;
  }

}
