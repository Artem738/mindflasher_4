import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:mindflasher_4/env_config.dart';
import 'package:mindflasher_4/models/user_model.dart';
import 'package:mindflasher_4/services/api_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telegram_web_app/telegram_web_app.dart';

class ProviderUserLogin extends ChangeNotifier {
  ProviderUserLogin() {
    initialize();
  }

  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  SharedPreferences? _sharedPreferences;
  TelegramUser? _telegramUser;
  UserModel? _userModel;

  bool get isLoading => _isLoading;

  bool get hasError => _hasError;

  String get errorMessage => _errorMessage;

  SharedPreferences? get sharedPreferences => _sharedPreferences;

  TelegramUser? get telegramUser => _telegramUser;

  UserModel? get userModel => _userModel;

  Future<void> initialize() async {
    await _initializeSharedPreferences();
    await _initializeTelegram();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _initializeSharedPreferences() async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
    } catch (e) {
      _hasError = true; // Устанавливаем флаг ошибки
      _errorMessage = e.toString(); // Сохраняем сообщение об ошибке
    }
  }

  Future<void> _initializeTelegram() async {
    try {
      if (TelegramWebApp.instance.isSupported) {
        await TelegramWebApp.instance.ready();
        _telegramUser = TelegramWebApp.instance.initData?.user;
        Future.delayed(const Duration(seconds: 1), TelegramWebApp.instance.expand);
        if (_telegramUser != null) {
          _userModel = UserModel(
            tgId: _telegramUser?.id,
            username: _telegramUser?.username,
            firstname: _telegramUser?.firstname,
            lastname: _telegramUser?.lastname,
            languageCode: _telegramUser?.languageCode,
            authDate: TelegramWebApp.instance.initData?.authDate,
            hash: TelegramWebApp.instance.initData?.hash,
          );
          // Логируем отправляемые данные
          ApiLogger.apiPrint('Отправляемые данные: ${_userModel!.toJson().toString()}');
          await _loginWithTelegram();
        }
      }
    } catch (e) {
      // Игнорируем ошибку, так как это нормальное поведение
    }
  }

  Future<void> _loginWithTelegram() async {
    const url = '${EnvConfig.mainApiUrl}/api/telegram/auth';
    final headers = {'Content-Type': 'application/json'};

    final initData = TelegramWebApp.instance.initData?.raw;

    ApiLogger.apiPrint("login vs Telegram $url");
    ApiLogger.apiPrint("Send initData: ${initData.toString()}");

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode({'initData': initData}),
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        // Обработка успешного ответа, например, сохранение токена
        _userModel = _userModel?.copyWith(token: responseData['token']);
        ApiLogger.apiPrint('Ошибка авторизации: ${responseData['token']}');
        notifyListeners();
      } else {
        // Обработка ошибки
        _hasError = true;
        _errorMessage = 'Ошибка авторизации: ${response.statusCode}';
        ApiLogger.apiPrint(_errorMessage);
        notifyListeners();
      }
    } catch (e) {
      // Обработка ошибки сети
      _hasError = true;
      _errorMessage = 'Ошибка сети: $e';
      ApiLogger.apiPrint(_errorMessage);
      notifyListeners();
    }
  }

  Future<void> loginWithEmail(String email, String password) async {
    const url = '${EnvConfig.mainApiUrl}/api/login';
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'email': email, 'password': password});

    try {
      final response = await http.post(Uri.parse(url), headers: headers, body: body);
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        _userModel = UserModel(
          token: responseData['access_token'],
          email: email,
        );
        notifyListeners();
      } else {
        _hasError = true;
        _errorMessage = 'Login failed!'; //  ${response.statusCode}
        notifyListeners();
      }
    } catch (e) {
      _hasError = true;
      _errorMessage = 'Network error: $e';
      notifyListeners();
    }
  }

  Future<void> registerWithEmail(String name, String email, String password, String passwordConfirmation) async {
    const url = '${EnvConfig.mainApiUrl}/api/register';
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
    });

    try {
      final response = await http.post(Uri.parse(url), headers: headers, body: body);
      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        _userModel = UserModel(token: responseData['access_token']);
        notifyListeners();
      } else {
        _hasError = true;
        _errorMessage = 'Registration failed: ${response.statusCode}';
        notifyListeners();
      }
    } catch (e) {
      _hasError = true;
      _errorMessage = 'Network error: $e';
      notifyListeners();
    }
  }

  void retry() {
    _isLoading = true;
    _hasError = false;
    _errorMessage = '';
    initialize();
    notifyListeners();
  }
}
