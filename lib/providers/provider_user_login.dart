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

  /** Shared Preferences */

  final String firstEnterSpName = "firstEnter_${EnvConfig.StorageAndSharedPreferencesKey}";
  final String lastEmailSpName = "lastEmail_${EnvConfig.StorageAndSharedPreferencesKey}";
  final String language_codeSpName = "language_${EnvConfig.StorageAndSharedPreferencesKey}";
  bool isSharedPreferencesLoaded = false;

  Future<void> _initializeSharedPreferences() async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();

      if (_sharedPreferences != null) {
        String? lastEmail = _sharedPreferences!.getString(lastEmailSpName);
        if (lastEmail != null) {
          _userModel.update(email: lastEmail);
        }
        String? language_code = _sharedPreferences!.getString(language_codeSpName);
        if (language_code != null) {
          _userModel.update(language_code: language_code);
        }

        bool? firstEnter = await _sharedPreferences!.getBool(firstEnterSpName);
        if (firstEnter == null) {
          _userModel.update(isFirstEnter: true);
          await _sharedPreferences!.setBool(firstEnterSpName, true);
        } else {
          _userModel.update(isFirstEnter: false);
          await _sharedPreferences!.setBool(firstEnterSpName, false);
        }
        isSharedPreferencesLoaded = true;
      }
    } catch (e) {
      isSharedPreferencesLoaded = false;

      /// ТАК и должно быть потому, что в телеграмме это не работает
      // _hasError = true;
      // _errorMessage = 'Error initializing SharedPreferences: $e';
      // ApiLogger.apiPrint("Error initializing SharedPreferences: $e");
    } finally {
      notifyListeners();
    }
  }

  Future<void> setIsFirstEnter(bool setVal) async {
    _userModel.update(
      isFirstEnter: setVal,
    );
    if (isSharedPreferencesLoaded) {
      await _sharedPreferences!.setBool(firstEnterSpName, setVal);
    }
    notifyListeners();
  }

  Future<void> _initializeSecureStorage() async {
    if (!kIsWeb) {
      _secureStorage = const FlutterSecureStorage();

      String? lastPass = await _secureStorage?.read(key: 'lastPass_${EnvConfig.StorageAndSharedPreferencesKey}');

      if (lastPass != null) {
        _lastPass = lastPass;
        print(_lastPass);
      } else {
        _lastPass = "";
      }
    }
  }

  bool isTelegramFeatureWorks = false;

  Future<void> _initializeTelegram() async {
    if (kIsWeb) {
      try {
        if (TelegramWebApp.instance.isSupported) {
          await TelegramWebApp.instance.ready();
          _telegramUser = TelegramWebApp.instance.initData?.user;
          expandTelegram();
          Future.delayed(const Duration(milliseconds: 10), TelegramWebApp.instance.expand);
          if (_telegramUser != null) {
            await _loginWithTelegram();
          }
          isTelegramFeatureWorks = true;
        }
      } catch (e) {
        bool isTelegramFeatureWorks = false;
        //
        // Заглушка: Здесь намеренно игнорируем ошибку. Тут нет ошибки. Оставляем этот комментарий.
        //
      } finally {
        notifyListeners();
      }
    } else {
      isTelegramFeatureWorks = false;
    }
  }

  Future<void> expandTelegram() async {
    if (isTelegramFeatureWorks) {
      Future.delayed(const Duration(milliseconds: 10), TelegramWebApp.instance.expand);
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
        body: jsonEncode({'initData': initData, 'language_code': userModel.language_code}),
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        ApiLogger.apiPrint("Tg login responseData: $responseData");

        final userData = responseData['user'];
        if (userData['base_font_size'] != null) {
          _userModel.update(base_font_size: userData['base_font_size'].toDouble());
        }
        _userModel?.update(
          apiId: userData['id'],
          telegram_id: userData['telegram_id'],
          name: userData['name'],
          email: userData['email'],
          tg_username: userData['tg_username'],
          tg_first_name: userData['tg_first_name'],
          tg_last_name: userData['tg_last_name'],
          tg_language_code: userData['tg_language_code'],
          language_code: userData['language_code'],
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
          await _sharedPreferences?.setString(lastEmailSpName, userData['email']);
        } else {
          ///TODO await _sharedPreferences?.remove(lastEmailSpName); // ???
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
        ApiLogger.apiPrint("user TO ADD: ${responseData['user']}");
        final userData = responseData['user'];
        if (userData['base_font_size'] != null) {
          _userModel.update(base_font_size: userData['base_font_size'].toDouble());
        }
        _userModel.update(
          apiId: userData['id'],
          email: email,
          name: userData['name'],
          token: responseData['access_token'],
          user_lvl: userData['user_lvl'],
          telegram_id: userData['telegram_id'],
          tg_username: userData['tg_username'],
          tg_first_name: userData['tg_first_name'],
          tg_last_name: userData['tg_last_name'],
          tg_language_code: userData['tg_language_code'],
          language_code: userData['language_code'],
          //userModel.base_font_size = userData['base_font_size'] ?? userModel.base_font_size,
        );
        // final userData = responseData['user'];

        ApiLogger.apiPrint("Login email done: ${_userModel.log()}");
        if (isSharedPreferencesLoaded) {
          await _sharedPreferences!.setString(lastEmailSpName, email);
        }
        if (!kIsWeb) {
          await _secureStorage?.write(key: 'lastPass_${EnvConfig.StorageAndSharedPreferencesKey}', value: password);
        }
        notifyListeners();
      } else {
        ApiLogger.apiPrint("loginWithEmail failed: $email $password");
      }
    } catch (e) {
      _hasError = true;
      _errorMessage = 'loginWithEmail Network error: $e';
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
      'language_code': _userModel.language_code,
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
      _errorMessage = 'registerWithEmail Network error: $e';
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
