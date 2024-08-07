import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mindflasher_4/env_config.dart';
import 'package:mindflasher_4/models/user_model.dart';
import 'package:mindflasher_4/services/api_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:flutter/foundation.dart' show kIsWeb; // Импортирует переменную kIsWeb которая используется для определения Web
import 'devise_special_load/telegram_web_app_stub.dart' // Импортируется заглушка для Классов
    if (dart.library.html) 'telegram_web_app_web.dart'; // Если библиотека dart.library.html доступна (приложение выполняется в веб-браузере),// то импортируется реальная реализация для веб-платформ

class ProviderUserLogin extends ChangeNotifier {
  final UserModel _userModel;

  ProviderUserLogin(this._userModel) {
    initialize();
  }

  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  SharedPreferences? _sharedPreferences;

  bool get isLoading => _isLoading;

  bool get hasError => _hasError;

  String get errorMessage => _errorMessage;

  SharedPreferences? get sharedPreferences => _sharedPreferences;

  UserModel get userModel => _userModel;

  TelegramUser? _telegramUser;

  TelegramUser? get telegramUser => _telegramUser;

  FlutterSecureStorage? _secureStorage;

  Future<void> initialize() async {
    await _initializeSharedPreferences();
    if (kIsWeb) {
      await _initializeTelegram();
    } else {
      await _initializeSecureStorage();
    }
    _isLoading = false;
    notifyListeners();
  }

  String _lastPass = '';
  String get lastPass => _lastPass;

  Future<void> _initializeSecureStorage() async {
    if (!kIsWeb) {
      _secureStorage = const FlutterSecureStorage();

      // Чтение данных из secure storage с проверкой на null
      String? lastPass = await _secureStorage?.read(key: 'lastPass');

      // Если значение отсутствует, lastPass будет равно null
      if (lastPass != null) {
        _lastPass = lastPass;
        print(_lastPass);
      } else {
        _lastPass = "";
      }
    }
  }

  Future<void> _initializeSharedPreferences() async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();

      String? lastEmail = sharedPreferences?.getString('lastEmail');
      if (lastEmail != null) {
        _userModel.update(
          email: lastEmail,
        );
      }
    } catch (e) {
      _hasError = true;
      _errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> _initializeTelegram() async {
    if (kIsWeb) {
      try {
        if (TelegramWebApp.instance.isSupported) {
          await TelegramWebApp.instance.ready();
          _telegramUser = TelegramWebApp.instance.initData?.user;
          Future.delayed(const Duration(seconds: 1), TelegramWebApp.instance.expand);
          if (_telegramUser != null) {
            _userModel.update(
              tgId: _telegramUser?.id,
              username: _telegramUser?.username,
              firstname: _telegramUser?.firstname,
              lastname: _telegramUser?.lastname,
              languageCode: _telegramUser?.languageCode,
              authDate: TelegramWebApp.instance.initData?.authDate,
              hash: TelegramWebApp.instance.initData?.hash,
            );
            await _loginWithTelegram();
          }
        }
      } catch (e) {
        //
        // Заглушка: Здесь намеренно игнорируем ошибку. Тут нет ошибки. Оставляем этот комментарий.
        //
      } finally {
        notifyListeners();
      }
    }
  }

  Future<void> _loginWithTelegram() async {
    const url = '${EnvConfig.mainApiUrl}/api/telegram/auth';
    final headers = {'Content-Type': 'application/json'};
    final initData = TelegramWebApp.instance.initData?.raw;

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode({'initData': initData}),
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        _userModel.update(token: responseData['token']);
        ApiLogger.apiPrint("Login with TG Success: ${_userModel.log()}");
      } else {
        _hasError = true;
        _errorMessage = 'Ошибка авторизации: ${response.statusCode}';
      }
    } catch (e) {
      _hasError = true;
      _errorMessage = 'Error TG login: $e';
      ApiLogger.apiPrint("Error TG login: $e ${_userModel.log()}");
    }
  }

  Future<void> loginWithEmail(String email, String password) async {
    const url = '${EnvConfig.mainApiUrl}/api/login';
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'email': email, 'password': password});
    await _sharedPreferences!.setString('lastEmail', email);
    await _secureStorage?.write(key: 'lastPass', value: password);
    try {
      final response = await http.post(Uri.parse(url), headers: headers, body: body);
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        _userModel.update(token: responseData['access_token'], email: email);
        ApiLogger.apiPrint("Login email done: ${_userModel.log()}");
        notifyListeners();
      } else {
        // Login failed: Nothing to do yet...
      }
    } catch (e) {
      _hasError = true;
      _errorMessage = 'Network error: $e';
      ApiLogger.apiPrint(_errorMessage);
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
        await loginWithEmail(email, password);
        if (_userModel.token != null) {
          ApiLogger.apiPrint("Register with email success: ${_userModel.log()}");
        }
      } else {
        _hasError = true;
        _errorMessage = 'Registration failed: ${response.statusCode}';
        ApiLogger.apiPrint(_errorMessage);
      }
    } catch (e) {
      _hasError = true;
      _errorMessage = 'Network error: $e';
      ApiLogger.apiPrint(_errorMessage);
    } finally {
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
