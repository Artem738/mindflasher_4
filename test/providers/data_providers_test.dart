import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mindflasher_4/env_config.dart';
import 'package:mindflasher_4/models/user_model.dart';
import 'package:mindflasher_4/providers/deck_provider.dart';
import 'package:mindflasher_4/providers/template_deck_provider.dart';
import 'package:mindflasher_4/providers/template_flashcard_provider.dart';
import 'package:mindflasher_4/services/app_http_client.dart';

void main() {
  setUp(() {
    EnvConfig.mainApiUrl = 'https://example.com';
  });

  group('DeckProvider', () {
    test('fetchDecks populates parsed deck models', () async {
      final provider = DeckProvider(
        UserModel(token: 'token'),
        httpClient: AppHttpClient(
          client: MockClient((request) async {
            expect(request.url.toString(), 'https://example.com/api/decks');
            expect(request.headers['Authorization'], 'Bearer token');
            return http.Response(
              '[{"id":1,"name":"Biology","description":"Cells"}]',
              200,
            );
          }),
        ),
      );

      await provider.fetchDecks();

      expect(provider.decks, hasLength(1));
      expect(provider.decks.first.name, 'Biology');
    });

    test('createDeck refreshes deck list after successful create', () async {
      var fetchCalls = 0;
      final provider = DeckProvider(
        UserModel(token: 'token'),
        httpClient: AppHttpClient(
          client: MockClient((request) async {
            if (request.method == 'POST') {
              return http.Response('{}', 201);
            }

            fetchCalls += 1;
            return http.Response(
              '[{"id":2,"name":"History","description":"Dates"}]',
              200,
            );
          }),
        ),
      );

      final created = await provider.createDeck('History', 'Dates');

      expect(created, isTrue);
      expect(fetchCalls, 1);
      expect(provider.decks.first.id, 2);
    });
  });

  group('TemplateDeckProvider', () {
    test('fetchDecks parses template deck payload', () async {
      final provider = TemplateDeckProvider(
        UserModel(token: 'token'),
        httpClient: AppHttpClient(
          client: MockClient((request) async {
            return http.Response(
              '[{"id":1,"name":"Category","lang":"en","children":[],"decks":[{"id":7,"name":"Starter","description":"Basics","deck_lang":"en","question_lang":"en","answer_lang":"uk"}]}]',
              200,
            );
          }),
        ),
      );

      await provider.fetchDecks();

      expect(provider.categories, hasLength(1));
      expect(provider.categories.first.decks, hasLength(1));
      expect(provider.categories.first.decks.first.answer_lang, 'uk');
    });
  });

  group('TemplateFlashcardProvider', () {
    test('fetchFlashcards parses template flashcards', () async {
      final provider = TemplateFlashcardProvider(
        UserModel(token: 'token'),
        httpClient: AppHttpClient(
          client: MockClient((request) async {
            expect(request.url.toString(), 'https://example.com/api/template-decks/3/flashcards');
            return http.Response(
              '[{"id":9,"deck_id":3,"question":"Q","answer":"A","weight":4}]',
              200,
            );
          }),
        ),
      );

      await provider.fetchFlashcards(3);

      expect(provider.templateFlashcards, hasLength(1));
      expect(provider.templateFlashcards.first.weight, 4);
    });
  });
}