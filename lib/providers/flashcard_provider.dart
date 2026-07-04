import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mindflasher_4/env_config.dart';
import 'package:mindflasher_4/models/deck_model.dart';

import 'package:mindflasher_4/models/flashcard_model.dart';
import 'package:mindflasher_4/models/user_model.dart';
import 'package:mindflasher_4/screens/list/central_top_card.dart';
import 'package:mindflasher_4/screens/list/left_swipe_card.dart';
import 'package:mindflasher_4/screens/list/right_answer_card.dart';
import 'package:mindflasher_4/screens/util/table_parser.dart';
import 'package:mindflasher_4/services/api_logger.dart';
import 'package:mindflasher_4/services/app_http_client.dart';


import '../tech_data/weight_delays_enum.dart'; // Импортируем Provider для получения токена

class FlashcardProvider with ChangeNotifier {
  FlashcardProvider(UserModel userModel, {AppHttpClient? httpClient})
      : _userModel = userModel,
        _httpClient = httpClient ?? AppHttpClient();

  UserModel _userModel;
  final AppHttpClient _httpClient;
  final List<FlashcardModel> _flashcards = [];
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  int? _currentlySwipedCardId;
  String _currentMode = 'srs';

  List<FlashcardModel> get flashcards => _flashcards;
  int? get currentlySwipedCardId => _currentlySwipedCardId;
  String get currentMode => _currentMode;

  void setCurrentlySwipedCardId(int? id) {
    if (_currentlySwipedCardId != id) {
      _currentlySwipedCardId = id;
      notifyListeners();
    }
  }

  void updateUserModel(UserModel userModel) {
    _userModel = userModel;
  }

  String _token() => _userModel.requireToken();

  Map<String, String> _headers() {
    return _httpClient.jsonHeaders(bearerToken: _token());
  }

  Future<void> fetchAndPopulateFlashcards(int deckId, {String mode = 'srs'}) async {
    _currentMode = mode;
    final apiUrl = '${EnvConfig.mainApiUrl}/api/decks/$deckId/flashcards?mode=$mode';
    final response = await _httpClient.get(
      Uri.parse(apiUrl),
      headers: _headers(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      _flashcards.clear(); // Очистим массив перед заполнением

      _flashcards.addAll(data.map((item) => FlashcardModel.fromJson(item)));
      _sortFlashcardsByWeight();
      notifyListeners();
    } else {
      throw AppHttpException('Failed to load flashcards', statusCode: response.statusCode);
    }
  }

  Future<List<FlashcardModel>> fetchAllFlashcardsForExport(int deckId) async {
    final apiUrl = '${EnvConfig.mainApiUrl}/api/decks/$deckId/flashcards?mode=all';
    final response = await _httpClient.get(
      Uri.parse(apiUrl),
      headers: _headers(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => FlashcardModel.fromJson(item)).toList();
    } else {
      throw AppHttpException('Failed to load flashcards for export', statusCode: response.statusCode);
    }
  }


  Future<bool> updateFlashcard(int deckId, int cardId, String question, String answer) async {
    final url = Uri.parse('${EnvConfig.mainApiUrl}/api/flashcards/$cardId');
    final response = await _httpClient.put(
      url,
      headers: _headers(),
      body: json.encode({
        'deck_id': deckId,
        'question': question,
        'answer': answer,
      }),
    );

    if (response.statusCode == 200) {
      final index = _flashcards.indexWhere((card) => card.id == cardId);
      if (index != -1) {
        _flashcards[index] = _flashcards[index].copyWith(
          question: question,
          answer: answer,
        );
        notifyListeners();
      }
      return true;
    }

    return false;
  }

  Future<bool> createFlashcard(
    int deckId,
    String question,
    String answer,
  ) async {
    final url = Uri.parse('${EnvConfig.mainApiUrl}/api/flashcards');

    final response = await _httpClient.post(
      url,
      headers: _headers(),
      body: json.encode({
        'deck_id': deckId,
        'question': question,
        'answer': answer,
      }),
    );
    if (response.statusCode == 201) {
      final Map<String, dynamic> data = json.decode(response.body);
      final newFlashcard = FlashcardModel.fromJson(data);
      _flashcards.add(newFlashcard);
      _sortFlashcardsByWeight();
      notifyListeners();
      return true;
    }

    return false;
  }

  // final url = "https://docs.google.com/spreadsheets/d/1bF-xeiOzezH-bKQAadJ8tpqDQH0iBVGExGVYklhXXco/pubhtml?gid=1056242600&single=true";

  Future<bool> importTable(int deckId, int questionColumn, int answerColumn) async {
    questionColumn = questionColumn > 0 ? questionColumn - 1 : 2;
    answerColumn = answerColumn > 0 ? answerColumn - 1 : 3;
    //final String url = "https://table.example.url";
    const url = "https://docs.google.com/spreadsheets/d/1qFEm9AQ6tq0a5W_ITX7yVcoUBhVrNiCe8k_x1xxufUs/pubhtml?gid=464824386&single=true";

    final response = await _httpClient.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var data = parseHtmlTable(response.body);

      // Убедимся, что questionColumn и answerColumn заданы корректно

      // Преобразование данных в CSV формат
      List<String> csvRows = [];
      for (var row in data) {
        if (row.length > answerColumn) {
          csvRows.add('${row[questionColumn]};${row[answerColumn]}');
        }
      }

      // Объединяем все строки в один CSV
      String csvData = csvRows.join('\n');

      debugPrint(csvData, wrapWidth: 200);

      if (await csvInsert(deckId, csvData)) {
        return true;
      }
    }
    return false;
  }


  Future<bool> csvInsert(int deckId, String csvData, {String delimiter = ';'}) async {
    final url = Uri.parse('${EnvConfig.mainApiUrl}/api/flashcards/csv-insert');

    final response = await _httpClient.post(
      url,
      headers: _headers(),
      body: json.encode({
        'deck_id': deckId,
        'csv_data': csvData,
        'delimiter': delimiter,
      }),
    );

    if (response.statusCode == 201) {
      return true;
    }

    return false;
  }

  Future<void> updateCardWeight(
    DeckModel deck,
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

      // Карточка удаляется насовсем из сессии только в режиме SRS при оценке Хорошо (зеленый).
      // В режиме ALL или при оценках Средне/Плохо она всегда переносится в конец списка.
      final bool shouldRemovePermanently = _currentMode == 'srs' && 
          weightDelayEnum == WeightDelaysEnum.goodLongDelay;

      if (!shouldRemovePermanently) {
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
      } else {
        notifyListeners();
      }

      try {
        // Обновление веса карточки на сервере
        final progressData = await updateCardWeightOnServer(id, weightDelayEnum);
        if (progressData != null) {
          // Если карточка была добавлена обратно (оценка Плохо) или асинхронно обновляется,
          // находим её по id и прописываем точные данные
          final cardIndex = _flashcards.indexWhere((card) => card.id == id);
          if (cardIndex != -1) {
            _flashcards[cardIndex] = _flashcards[cardIndex].copyWith(
              weight: progressData['weight'] ?? _flashcards[cardIndex].weight,
              lastAnswerWeight: progressData['last_answer_weight'],
              easeFactor: progressData['ease_factor'] != null 
                  ? double.parse(progressData['ease_factor'].toString()) 
                  : _flashcards[cardIndex].easeFactor,
              intervalDays: progressData['interval_days'] ?? _flashcards[cardIndex].intervalDays,
              nextReviewAt: progressData['next_review_at'],
              lastReviewedAt: progressData['last_reviewed_at'],
            );
            notifyListeners();
          }
        }
      } catch (e) {
        debugPrint('Error updating weight on server: $e');
      }
    }
  }

  Future<Map<String, dynamic>?> updateCardWeightOnServer(int id, WeightDelaysEnum weightDelayEnum) async {
    ///flashcards/{flashcardId}/progress/weight'
    final url = Uri.parse('${EnvConfig.mainApiUrl}/api/flashcards/$id/progress/weight');
    final response = await _httpClient.post(
      url,
      headers: _headers(),
      body: json.encode({'weight': weightDelayEnum.value, 'last_answer_weight': weightDelayEnum.value}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['progress'] as Map<String, dynamic>?;
    } else {
      const err = 'updateCardWeightOnServer: Failed to update weight on server';
      ApiLogger.apiPrint(err);
      throw AppHttpException(err, statusCode: response.statusCode);
    }
  }

  Future<bool> deleteFlashcard(int cardId) async {
    final url = Uri.parse('${EnvConfig.mainApiUrl}/api/flashcards/$cardId');
    final response = await _httpClient.delete(
      url,
      headers: _headers(),
    );

    if (response.statusCode == 200) {
      final index = _flashcards.indexWhere((card) => card.id == cardId);
      if (index != -1) {
        listKey.currentState?.removeItem(
          index,
          (context, animation) => const SizedBox.shrink(), // Удаляем виджет с анимацией
        );
        _flashcards.removeAt(index);
        notifyListeners();
      }
      return true;
    }

    return false;
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
          stopThreshold: 0.9, // Пример значения для другого экрана
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
