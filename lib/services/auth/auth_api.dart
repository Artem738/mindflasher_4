import 'dart:convert';

import 'package:mindflasher_4/env_config.dart';
import 'package:mindflasher_4/services/app_http_client.dart';

class AuthApiResponse {
  const AuthApiResponse({required this.userData, required this.token});

  final Map<String, dynamic> userData;
  final String token;
}

abstract class AuthApi {
  Future<AuthApiResponse> loginWithEmail({required String email, required String password});

  Future<void> registerWithEmail({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String? languageCode,
  });

  Future<AuthApiResponse> loginWithTelegram({required String initData, required String? languageCode});

  Future<AuthApiResponse> loginWithWebKey({required String key});
}

class LaravelAuthApi implements AuthApi {
  LaravelAuthApi({AppHttpClient? httpClient}) : _httpClient = httpClient ?? AppHttpClient();

  final AppHttpClient _httpClient;

  @override
  Future<AuthApiResponse> loginWithEmail({required String email, required String password}) async {
    final response = await _httpClient.post(
      Uri.parse('${EnvConfig.mainApiUrl}/api/login'),
      headers: _httpClient.jsonHeaders(),
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode != 200) {
      String errorMessage = 'Login failed';
      try {
        final decoded = jsonDecode(response.body);
        if (decoded['errors'] != null) {
          final errors = decoded['errors'] as Map<String, dynamic>;
          if (errors.isNotEmpty) {
            errorMessage = (errors.values.first as List).first.toString();
          }
        } else if (decoded['message'] != null) {
          errorMessage = decoded['message'];
        }
      } catch (_) {}
      throw AppHttpException(errorMessage, statusCode: response.statusCode);
    }

    final responseData = jsonDecode(response.body) as Map<String, dynamic>;
    return AuthApiResponse(
      userData: responseData['user'] as Map<String, dynamic>,
      token: responseData['access_token'] as String,
    );
  }

  @override
  Future<void> registerWithEmail({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String? languageCode,
  }) async {
    final response = await _httpClient.post(
      Uri.parse('${EnvConfig.mainApiUrl}/api/register'),
      headers: _httpClient.jsonHeaders(),
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'language_code': languageCode,
      }),
    );

    if (response.statusCode != 201) {
      String errorMessage = 'Registration failed';
      try {
        final decoded = jsonDecode(response.body);
        if (decoded['errors'] != null) {
          final errors = decoded['errors'] as Map<String, dynamic>;
          if (errors.isNotEmpty) {
            errorMessage = (errors.values.first as List).first.toString();
          }
        } else if (decoded['message'] != null) {
          errorMessage = decoded['message'];
        }
      } catch (_) {}
      throw AppHttpException(errorMessage, statusCode: response.statusCode);
    }
  }

  @override
  Future<AuthApiResponse> loginWithTelegram({required String initData, required String? languageCode}) async {
    final response = await _httpClient.post(
      Uri.parse('${EnvConfig.mainApiUrl}/api/telegram/auth'),
      headers: _httpClient.jsonHeaders(),
      body: jsonEncode({'initData': initData, 'language_code': languageCode}),
    );

    if (response.statusCode != 200) {
      throw AppHttpException('Telegram login failed', statusCode: response.statusCode);
    }

    final responseData = jsonDecode(response.body) as Map<String, dynamic>;
    return AuthApiResponse(
      userData: responseData['user'] as Map<String, dynamic>,
      token: responseData['token'] as String,
    );
  }

  @override
  Future<AuthApiResponse> loginWithWebKey({required String key}) async {
    final response = await _httpClient.post(
      Uri.parse('${EnvConfig.mainApiUrl}/api/web-login'),
      headers: _httpClient.jsonHeaders(),
      body: jsonEncode({'key': key}),
    );

    if (response.statusCode != 200) {
      String errorMessage = 'Web login failed';
      try {
        final decoded = jsonDecode(response.body);
        if (decoded['errors'] != null) {
          final errors = decoded['errors'] as Map<String, dynamic>;
          if (errors.isNotEmpty) {
            errorMessage = (errors.values.first as List).first.toString();
          }
        } else if (decoded['message'] != null) {
          errorMessage = decoded['message'];
        }
      } catch (_) {}
      throw AppHttpException(errorMessage, statusCode: response.statusCode);
    }

    final responseData = jsonDecode(response.body) as Map<String, dynamic>;
    return AuthApiResponse(
      userData: responseData['user'] as Map<String, dynamic>,
      token: responseData['access_token'] as String,
    );
  }
}