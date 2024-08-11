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
    if (dart.library.html) 'devise_special_load/telegram_web_app_web.dart'; // Если библиотека dart.library.html доступна (приложение выполняется в веб-браузере),// то импортируется реальная реализация для веб-платформ

class ProviderUserLogin extends ChangeNotifier {
  final UserModel _userModel;

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

  String _lastPass = '';

  String get lastPass => _lastPass;

  /// Initialise Class on First Run!
  ProviderUserLogin(this._userModel) {
    // Класс инициализируется сразу.
    initialize();
  }

  Future<void> initialize() async {
    if (kIsWeb) {
      EnvConfig.mainApiUrl = EnvConfig.webApiUrl;
    } else {
      EnvConfig.mainApiUrl = EnvConfig.localApiUrl;
    }
    await _initializeSharedPreferences();
    if (kIsWeb) {
      await _initializeTelegram();
    } else {
      await _initializeSecureStorage();
    }

    notifyListeners();
    _isLoading = false;
  }

  final String _firstEnterSpName = "firstEnterB451";

  Future<void> _initializeSharedPreferences() async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();

      if (_sharedPreferences != null) {
        String? lastEmail = _sharedPreferences!.getString('lastEmail');
        ApiLogger.apiPrint("Last email loaded: $lastEmail");

        if (lastEmail != null) {
          _userModel.update(email: lastEmail);
        } else {
          ApiLogger.apiPrint("No email found in SharedPreferences.");
        }

        bool? firstEnter = await _sharedPreferences!.getBool(_firstEnterSpName);
        ApiLogger.apiPrint("First enter flag loaded: $firstEnter");

        if (firstEnter == null) {
          _userModel.update(firstEnter: true);
          await _sharedPreferences!.setBool(_firstEnterSpName, true);
          ApiLogger.apiPrint("First enter flag set to true.");
        } else {
          _userModel.update(firstEnter: false);
          await _sharedPreferences!.setBool(_firstEnterSpName, false);
          ApiLogger.apiPrint("First enter flag set to false.");
        }

        ApiLogger.apiPrint("UserModel updated: ${_userModel.log()}");
      } else {
        _hasError = true;
        _errorMessage = 'SharedPreferences is null';
        ApiLogger.apiPrint("Error: SharedPreferences is null");
      }
    } catch (e) {
      _hasError = true;
      _errorMessage = 'Error initializing SharedPreferences: $e';
      ApiLogger.apiPrint("Error initializing SharedPreferences: $e");
    } finally {
      notifyListeners();
    }
  }

  Future<void> setFirstEnterSharedPreferences() async {
    _userModel.update(
      firstEnter: false,
    );
    await _sharedPreferences!.setBool(_firstEnterSpName, false);

    notifyListeners();
  }

  Future<void> _initializeSecureStorage() async {
    if (!kIsWeb) {
      _secureStorage = const FlutterSecureStorage();

      String? lastPass = await _secureStorage?.read(key: 'lastPass');

      if (lastPass != null) {
        _lastPass = lastPass;
        print(_lastPass);
      } else {
        _lastPass = "";
      }
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
    final url = '${EnvConfig.mainApiUrl}/api/telegram/auth';
    final headers = {'Content-Type': 'application/json'};
    final initData = TelegramWebApp.instance.initData?.raw;

    if (initData == null) {
      _hasError = true;
      _errorMessage = 'Init data is null';
      ApiLogger.apiPrint("Init data is null: ${_userModel?.log()}");
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode({'initData': initData}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        ApiLogger.apiPrint("Tg login responseData: $responseData");

        final userData = responseData['user'];

        // Обновляем модель пользователя данными из ответа сервера
        _userModel?.update(
          apiId: userData['id'],
          telegram_id: userData['telegram_id'],
          email: userData['email'],
          tg_username: userData['tg_username'],
          firstname: userData['tg_first_name'],
          tg_last_name: userData['tg_last_name'],
          languageCode: userData['language_code'],
          token: responseData['token'],
          authDate: userData['auth_date'],
          user_lvl: userData['user_lvl'],
        );

        if (_userModel == null) {
          _hasError = true;
          _errorMessage = 'UserModel is null';
          ApiLogger.apiPrint("UserModel is null");
          return;
        }

        // Необходимое удаление email если был логин с email, но не зарегистрированный.
        if (userData['email'] != null) {
          await _sharedPreferences?.setString('lastEmail', userData['email']);
        } else {
          // await _sharedPreferences?.remove('lastEmail');
        }
        ApiLogger.apiPrint("Login with TG Success: ${_userModel.log()}");
      } else {
        _hasError = true;
        _errorMessage = 'Ошибка авторизации: ${response.statusCode}';
      }
    } catch (e) {
      _hasError = true;
      _errorMessage = 'Error TG login: $e';
      ApiLogger.apiPrint("Error TG login: $e ${_userModel?.log()}");
    }
  }

  Future<void> loginWithEmail(String email, String password) async {
    ApiLogger.apiPrint('loginWithEmail flutter: $email $password');
    final url = '${EnvConfig.mainApiUrl}/api/login';
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'email': email, 'password': password});

    try {
      final response = await http.post(Uri.parse(url), headers: headers, body: body);
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        _userModel.update(token: responseData['access_token'], email: email);
        ApiLogger.apiPrint("Login email done: ${_userModel.log()}");
        await _sharedPreferences!.setString('lastEmail', email);
        if (!kIsWeb) {
          await _secureStorage?.write(key: 'lastPass', value: password);
        }
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
    final url = '${EnvConfig.mainApiUrl}/api/register';
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
