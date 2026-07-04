
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mindflasher_4/services/app_http_client.dart';

void main() {
  group('AppHttpClient', () {
    test('merges JSON headers with bearer token', () {
      final client = AppHttpClient();

      final headers = client.jsonHeaders(
        bearerToken: 'abc',
        extraHeaders: const {'Accept': 'application/json'},
      );

      expect(headers['Content-Type'], 'application/json');
      expect(headers['Authorization'], 'Bearer abc');
      expect(headers['Accept'], 'application/json');
    });

    test('returns successful responses unchanged', () async {
      final mockClient = MockClient((request) async {
        expect(request.method, 'GET');
        return http.Response('{"ok":true}', 200);
      });
      final client = AppHttpClient(client: mockClient);

      final response = await client.get(Uri.parse('https://example.com/ping'));

      expect(response.statusCode, 200);
      expect(response.body, '{"ok":true}');
    });

    test('wraps timeout failures in AppHttpException', () async {
      final mockClient = MockClient((request) async {
        await Future<void>.delayed(const Duration(milliseconds: 20));
        return http.Response('late', 200);
      });
      final client = AppHttpClient(
        client: mockClient,
        timeout: const Duration(milliseconds: 1),
      );

      await expectLater(
        client.get(Uri.parse('https://example.com/slow')),
        throwsA(
          isA<AppHttpException>().having(
            (error) => error.message,
            'message',
            'Request timed out',
          ),
        ),
      );
    });
  });
}