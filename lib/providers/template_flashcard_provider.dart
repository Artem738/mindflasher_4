import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mindflasher_4/env_config.dart';
import 'package:mindflasher_4/models/flashcard_model.dart';
import 'package:mindflasher_4/providers/deck_provider.dart';
import 'package:provider/provider.dart';

class TemplateFlashcardProvider extends ChangeNotifier {
  List<FlashcardModel> _flashcards = [];

  List<FlashcardModel> get flashcards => _flashcards;


  Future<void> fetchFlashcards(int deckId, String token) async {
    String apiUrl = '${EnvConfig.mainApiUrl}/api/template-decks/$deckId/flashcards';
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      _flashcards.clear();

      for (var item in data) {
        _flashcards.add(FlashcardModel(
          id: item['id'],
          deckId: item['deck_id'],
          question: item['question'],
          answer: item['answer'],
          weight: item['weight'],
        ));
      }
      notifyListeners();
    } else {
      throw Exception('Failed to load flashcards');
    }
  }

  Future<bool> addTemplateBaseToUser(BuildContext context, int templateDeckId, String token) async {
    String apiUrl = '${EnvConfig.mainApiUrl}/api/add-template-to-user';
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'template_deck_id': templateDeckId,
      }),
    );

    if (response.statusCode == 200) {
      await Provider.of<DeckProvider>(context, listen: false).fetchDecks(token);
      print('Template base added to user');
      notifyListeners();
      return true; // Успешное выполнение
    } else {
      print(response.body);
      return false; // Неудача
    }
  }

}
