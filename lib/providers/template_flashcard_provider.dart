import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mindflasher_4/env_config.dart';
import 'package:mindflasher_4/models/flashcard_model.dart';

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
}
