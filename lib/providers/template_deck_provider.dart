import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mindflasher_4/env_config.dart';
import 'package:mindflasher_4/models/template_deck_model.dart';

class TemplateDeckProvider extends ChangeNotifier {
  List<TemplateDeckModel> _templateDecks = [];

  List<TemplateDeckModel> get decks => _templateDecks;

  Future<void> fetchDecks(String token) async {
    String apiUrl = '${EnvConfig.mainApiUrl}/api/template-decks';
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
      _templateDecks.clear();

      for (var item in data) {
        _templateDecks.add(TemplateDeckModel(
          id: item['id'],
          name: item['name'],
          description: item['description'],
          deck_lang: item['deck_lang'],
          question_lang: item['question_lang'],
          answer_lang: item['answer_lang'],
        ));
      }
      notifyListeners();
    } else {
      throw Exception('Failed to load decks');
    }
  }
}
