import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mindflasher_4/env_config.dart';
import 'package:mindflasher_4/models/deck_model.dart';

import 'package:mindflasher_4/models/flashcard_model.dart';
import 'package:mindflasher_4/providers/deck_provider.dart';
import 'package:mindflasher_4/screens/list/central_top_card.dart';
import 'package:mindflasher_4/screens/list/left_swipe_card.dart';
import 'package:mindflasher_4/screens/list/right_answer_card.dart';
import 'package:mindflasher_4/services/api_logger.dart';
import 'package:mindflasher_4/tech_data/words_translations.dart';

import 'package:provider/provider.dart';

import '../tech_data/weight_delays_enum.dart'; // Импортируем Provider для получения токена

class FlashcardProvider with ChangeNotifier {
  final List<FlashcardModel> _flashcards = [];
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  List<FlashcardModel> get flashcards => _flashcards;

  Future<void> fetchAndPopulateFlashcards(String token, int deckId) async {
    if (token == null) {
      throw Exception('User not authenticated');
    }

    final apiUrl = '${EnvConfig.mainApiUrl}/api/decks/$deckId/flashcards';
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      _flashcards.clear(); // Очистим массив перед заполнением

      for (var item in data) {
        _flashcards.add(FlashcardModel(
          id: item['id'],
          question: item['question'],
          answer: item['answer'],
          weight: item['weight'] ?? 0,
          // Если weight отсутствует, используем 0
          deckId: item['deck_id'],
          // Добавляем поле deckId
          lastReviewedAt: item['last_reviewed_at'],
          // Добавляем поле lastReviewedAt
          lastAnswerWeight: item['last_answer_weight'], // Добавляем поле lastReviewedAt
        ));
      }
      _sortFlashcardsByWeight();
      notifyListeners();
    } else {
      throw Exception('Failed to load flashcards');
    }
  }

  Future<bool> updateFlashcard(int deckId, int cardId, String question, String answer, String token) async {
    if (token == null) {
      throw Exception('User not authenticated');
    }

    print (deckId);
    print ("wtf");


    final url = Uri.parse('${EnvConfig.mainApiUrl}/api/flashcards/$cardId');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'deck_id': deckId,
        'question': question,
        'answer': answer,
      }),
    );

    if (response.statusCode == 200) {
      print (response.body);

      final index = _flashcards.indexWhere((card) => card.id == cardId);
      if (index != -1) {
        _flashcards[index] = _flashcards[index].copyWith(
          question: question,
          answer: answer,
        );
        notifyListeners();
      }
      return true;
    } else {
      print('Failed to update flashcard: ${response.body}');
      return false;
    }
  }

  Future<bool> createFlashcard(
    int deckId,
    String question,
    String answer,
    String token,
  ) async {
    if (token == null) {
      throw Exception('User not authenticated');
    }

    final url = Uri.parse('${EnvConfig.mainApiUrl}/api/flashcards');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'deck_id': deckId,
        'question': question,
        'answer': answer,
      }),
    );
    if (response.statusCode == 201) {
      final Map<String, dynamic> data = json.decode(response.body);
      final newFlashcard = FlashcardModel(
        id: data['id'],
        question: data['question'],
        answer: data['answer'],
        weight: data['weight'] ?? 0,
        deckId: data['deck_id'],
      );
      _flashcards.add(newFlashcard);
      _sortFlashcardsByWeight();
      notifyListeners();
      return true;
    } else {
      print('Failed to create flashcard: ${response.body}');
      return false;
    }
  }

  Future<void> updateCardWeight(
    DeckModel deck,
    String token,
    int id,
    WeightDelaysEnum weightDelayEnum,
  ) async {
    int tileCloseTime = 220;
    int tileOpenTime = 400;

    final index = _flashcards.indexWhere((card) => card.id == id);
    if (index != -1) {
      final flashcard = _flashcards[index];
      final updatedCard = flashcard.copyWith(
        weight: flashcard.weight + weightDelayEnum.value,
        lastAnswerWeight: weightDelayEnum.value,
      );

      listKey.currentState?.removeItem(
        index,
        (context, animation) => _buildRemovedCardItem(deck, flashcard, animation, weightDelayEnum),
        duration: Duration(milliseconds: tileCloseTime),
      );

      _flashcards.removeAt(index);
      Future.delayed(const Duration(milliseconds: 10), () {
        _flashcards.add(updatedCard);
        _sortFlashcardsByWeight();
        final newIndex = _flashcards.indexOf(updatedCard);
        listKey.currentState?.insertItem(
          newIndex,
          duration: Duration(milliseconds: tileOpenTime),
        );
        notifyListeners();
      });

      // Обновление веса карточки на сервере
      await updateCardWeightOnServer(token, id, weightDelayEnum);
    }
  }

  Future<void> updateCardWeightOnServer(String token, int id, WeightDelaysEnum weightDelayEnum) async {
    // Получение токена из UserProvider
    if (token == null) {
      throw Exception('User not authenticated');
    }
    //print(weightDelayEnum.name);
    print(weightDelayEnum.value);
//
    ///flashcards/{flashcardId}/progress/weight'
    final url = Uri.parse('${EnvConfig.mainApiUrl}/api/flashcards/$id/progress/weight');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'weight': weightDelayEnum.value, 'last_answer_weight': weightDelayEnum.value}),
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode != 200) {
      String err = 'updateCardWeightOnServer: Failed to update weight on server';
      ApiLogger.apiPrint(err);
      throw Exception(err);
    }
  }

  Future<bool> deleteFlashcard(int cardId, String token) async {
    if (token == null) {
      throw Exception('User not authenticated');
    }

    final url = Uri.parse('${EnvConfig.mainApiUrl}/api/flashcards/$cardId');
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final index = _flashcards.indexWhere((card) => card.id == cardId);
      if (index != -1) {
        listKey.currentState?.removeItem(
          index,
              (context, animation) => SizedBox.shrink(), // Удаляем виджет с анимацией
        );
        _flashcards.removeAt(index);
        notifyListeners();
      }
      return true;
    } else {
      print('Failed to delete flashcard: ${response.body}');
      return false;
    }
  }


  void _sortFlashcardsByWeight() {
    _flashcards.sort((a, b) {
      int weightComparison = a.weight.compareTo(b.weight);
      if (weightComparison != 0) {
        return weightComparison;
      } else {
        return a.id.compareTo(b.id); // Сортировка по id если веса совпадают
      }
    });
  }

  Widget _buildRemovedCardItem(DeckModel deck, FlashcardModel card, Animation<double> animation, WeightDelaysEnum weightDelayEnum) {
    if (weightDelayEnum == WeightDelaysEnum.noDelay) {
      return SizeTransition(
        sizeFactor: animation,
        child: LeftSwipeCard(
          deck: deck,
          flashcard: card,
          stopThreshold: 0.4, // DRY !!!!
        ),
      );
    } else if (weightDelayEnum == WeightDelaysEnum.badSmallDelay || weightDelayEnum == WeightDelaysEnum.normMedDelay) {
      return SizeTransition(
        sizeFactor: animation,
        child: RightAnswerCard(
          deck: deck,
          flashcard: card,
          stopThreshold: 0.9,  // Пример значения для другого экрана
        ),
      );
    } else if (weightDelayEnum == WeightDelaysEnum.goodLongDelay) {
      return SizeTransition(
        sizeFactor: animation,
        child: CentralTopCard(
          deck: deck,
          flashcard: card,
        ),
      );
    } else {
      return SizeTransition(
        sizeFactor: animation,
        child: CentralTopCard(
          deck: deck,
          flashcard: card,
        ),
      );
    }
  }
}
