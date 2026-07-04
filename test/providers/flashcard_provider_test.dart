import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mindflasher_4/env_config.dart';
import 'package:mindflasher_4/models/user_model.dart';
import 'package:mindflasher_4/providers/flashcard_provider.dart';
import 'package:mindflasher_4/services/app_http_client.dart';
import 'package:mindflasher_4/tech_data/weight_delays_enum.dart';

void main() {
  setUp(() {
    EnvConfig.mainApiUrl = 'https://example.com';
  });

  test('fetchAndPopulateFlashcards sorts by weight then id', () async {
    final provider = FlashcardProvider(
      UserModel(token: 'token'),
      httpClient: AppHttpClient(
        client: MockClient((request) async {
          return http.Response(
            '[{"id":2,"question":"Second","answer":"B","weight":5,"deck_id":1},'
            '{"id":1,"question":"First","answer":"A","weight":1,"deck_id":1}]',
            200,
          );
        }),
      ),
    );

    await provider.fetchAndPopulateFlashcards(1);

    expect(provider.flashcards, hasLength(2));
    expect(provider.flashcards.first.id, 1);
    expect(provider.flashcards.last.id, 2);
  });

  test('createFlashcard appends parsed flashcard on success', () async {
    final provider = FlashcardProvider(
      UserModel(token: 'token'),
      httpClient: AppHttpClient(
        client: MockClient((request) async {
          expect(request.method, 'POST');
          return http.Response(
            '{"id":4,"question":"New","answer":"Item","weight":0,"deck_id":1}',
            201,
          );
        }),
      ),
    );

    final created = await provider.createFlashcard(1, 'New', 'Item');

    expect(created, isTrue);
    expect(provider.flashcards.single.question, 'New');
  });

  test('updateCardWeightOnServer sends weight payload', () async {
    final provider = FlashcardProvider(
      UserModel(token: 'token'),
      httpClient: AppHttpClient(
        client: MockClient((request) async {
          expect(request.url.toString(), 'https://example.com/api/flashcards/8/progress/weight');
          expect(request.body, '{"weight":1,"last_answer_weight":1}');
          return http.Response('{}', 200);
        }),
      ),
    );

    await provider.updateCardWeightOnServer(8, WeightDelaysEnum.badSmallDelay);
  });
}