import 'package:flutter_test/flutter_test.dart';
import 'package:mindflasher_4/app/app_bootstrap_route.dart';

void main() {
  group('resolveAppBootstrapRoute', () {
    test('returns loading while auth bootstrap is running', () {
      final route = resolveAppBootstrapRoute(
        isLoading: true,
        languageCode: null,
        token: null,
      );

      expect(route, AppBootstrapRoute.loading);
    });

    test('returns language selection when language is missing', () {
      final route = resolveAppBootstrapRoute(
        isLoading: false,
        languageCode: null,
        token: 'token',
      );

      expect(route, AppBootstrapRoute.languageSelection);
    });

    test('returns login when language exists but token is missing', () {
      final route = resolveAppBootstrapRoute(
        isLoading: false,
        languageCode: 'en',
        token: null,
      );

      expect(route, AppBootstrapRoute.login);
    });

    test('returns decks for a ready authenticated user', () {
      final route = resolveAppBootstrapRoute(
        isLoading: false,
        languageCode: 'en',
        token: 'token',
      );

      expect(route, AppBootstrapRoute.decks);
    });
  });
}
