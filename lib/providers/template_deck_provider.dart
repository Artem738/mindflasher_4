import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mindflasher_4/env_config.dart';
import 'package:mindflasher_4/models/template_deck_model.dart';

class DeckProvider extends ChangeNotifier {
  List<TemplateDeckModel> _decks = [];

  List<TemplateDeckModel> get decks => _decks;

  Future<void> fetchDeck(String token) async {
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
      _decks.clear();

      for (var item in data) {
        _decks.add(TemplateDeckModel(
          id: item['id'],
          name: item['name'],
          description: item['description'],
        ));
      }
      notifyListeners();
    } else {
      throw Exception('Failed to load decks');
    }
  }
}
