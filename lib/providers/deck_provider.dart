import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:mindflasher_4/env_config.dart';
import 'package:mindflasher_4/models/deck_model.dart';

class DeckProvider extends ChangeNotifier {
  List<DeckModel> _decks = [];

  List<DeckModel> get decks => _decks;

  // Метод для создания новой колоды
  Future<bool> createDeck(String name, String description, String token, {int? templateDeckId}) async {
    String apiUrl = '${EnvConfig.mainApiUrl}/api/decks';
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'description': description,
        'template_deck_id': templateDeckId,
      }),
    );

    if (response.statusCode == 201) {
      await fetchDecks(token);
      print('Deck created successfully');
      return true; // Успешное выполнение
    } else {
      print(response.body);
      return false; // Неудача
    }
  }

  // Метод для обновления существующей колоды
  Future<bool> updateDeck(int deckId, String name, String description, String token) async {
    String apiUrl = '${EnvConfig.mainApiUrl}/api/decks/$deckId';
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'description': description,
      }),
    );

    if (response.statusCode == 200) {
      await fetchDecks(token);
      print('Deck updated successfully');
      return true; // Успешное выполнение
    } else {
      print(response.body);
      return false; // Неудача
    }
  }

  // Метод для получения одной колоды по ID
  Future<DeckModel?> getDeck(int deckId, String token) async {
    String apiUrl = '${EnvConfig.mainApiUrl}/api/decks/$deckId';
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return DeckModel.fromJson(data);
    } else {
      print(response.body);
      return null; // Возвращаем null, если не удалось получить данные
    }
  }

  // Метод для удаления колоды пользователя
  Future<bool> deleteUserDeck(int deckId, String token) async {
    String apiUrl = '${EnvConfig.mainApiUrl}/api/decks/$deckId';
    final response = await http.delete(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      await fetchDecks(token);
      print('Deck deleted successfully');
      notifyListeners();
      return true; // Успешное выполнение
    } else {
      print(response.body);
      return false; // Неудача
    }
  }

  // Метод для получения всех колод пользователя
  Future<void> fetchDecks(String token) async {
    String apiUrl = '${EnvConfig.mainApiUrl}/api/decks';
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
        _decks.add(DeckModel.fromJson(item));
      }
      notifyListeners();
    } else {
      throw Exception('Failed to load decks');
    }
  }
}
