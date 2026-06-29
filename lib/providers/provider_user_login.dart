import 'package:flutter/material.dart';
import 'package:mindflasher_4/env_config.dart';
import 'package:mindflasher_4/models/user_model.dart';
import 'package:mindflasher_4/services/api_logger.dart';
import 'package:mindflasher_4/services/auth/auth_api.dart';
import 'package:mindflasher_4/services/auth/auth_local_store.dart';
import 'package:mindflasher_4/services/auth/telegram_auth_bridge.dart';
import 'package:mindflasher_4/services/logging/app_logger.dart';

import 'package:flutter/foundation.dart' show kIsWeb; // Импортирует переменную kIsWeb которая используется для определения Web
// Если библиотека dart.library.html доступна (приложение выполняется в веб-браузере),// то импортируется реальная реализация для веб-платформ

class ProviderUserLogin extends ChangeNotifier {
  final UserModel _userModel;
  final AuthApi _authApi;
  final AuthLocalStore _authLocalStore;
  final TelegramAuthBridge _telegramAuthBridge;
  final AppLogger _logger;

  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  bool _isLocalPreferencesAvailable = false;

  bool get isLoading => _isLoading;

  bool get hasError => _hasError;

  String get errorMessage => _errorMessage;

  bool get isLocalPreferencesAvailable => _isLocalPreferencesAvailable;

  UserModel get userModel => _userModel;

  TelegramUser? _telegramUser;

  TelegramUser? get telegramUser => _telegramUser;

  String _lastPass = '';

  String get lastPass => _lastPass;

  /// Initialise Class on First Run!
  ProviderUserLogin(
    this._userModel, {
    AuthApi? authApi,
    AuthLocalStore? authLocalStore,
    TelegramAuthBridge? telegramAuthBridge,
    AppLogger? logger,
    bool autoInitialize = true,
  })  : _authApi = authApi ?? LaravelAuthApi(),
        _authLocalStore = authLocalStore ?? DeviceAuthLocalStore(),
        _telegramAuthBridge = telegramAuthBridge ?? TelegramWebAppBridge(),
        _logger = logger ?? AppLogger.instance {
    if (autoInitialize) {
      initialize();
    }
  }

  Future<void> initialize() async {
    _isLoading = true;
    _hasError = false;
    _errorMessage = '';
    notifyListeners();

    try {
      if (kIsWeb) {
        EnvConfig.mainApiUrl = EnvConfig.normalizeApiBaseUrl(EnvConfig.webApiUrl);
        _logger.info('bootstrap', 'Running in web mode');
      } else {
        EnvConfig.mainApiUrl = EnvConfig.normalizeApiBaseUrl(EnvConfig.localApiUrl);
        _logger.info('bootstrap', 'Running in app mode');
      }

      await _loadLocalState();
      await _initializeTelegram();
    } catch (e) {
      _hasError = true;
      _errorMessage = 'Initialization error: $e';
      _logger.error('auth', _errorMessage);
      ApiLogger.apiPrint(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadLocalState() async {
    final localState = await _authLocalStore.load();
    _isLocalPreferencesAvailable = localState.isPreferencesAvailable;
    _lastPass = localState.lastPassword;
    _logger.info(
      'auth',
      'Local auth state loaded: prefs=${localState.isPreferencesAvailable}, language=${localState.languageCode ?? 'none'}, theme=${localState.themeMode ?? 'none'}, firstEnter=${localState.isFirstEnter}',
    );

    ThemeMode themeMode = ThemeMode.system;
    if (localState.themeMode == 'light') themeMode = ThemeMode.light;
    if (localState.themeMode == 'dark') themeMode = ThemeMode.dark;

    _userModel.update(
      email: localState.lastEmail,
      language_code: localState.languageCode,
      isFirstEnter: localState.isFirstEnter,
      themeMode: themeMode,
    );
  }

  Future<void> saveThemeMode(ThemeMode themeMode) async {
    _userModel.update(themeMode: themeMode);
    String themeString = 'system';
    if (themeMode == ThemeMode.light) themeString = 'light';
    if (themeMode == ThemeMode.dark) themeString = 'dark';
    await _authLocalStore.saveThemeMode(themeString);
    notifyListeners();
  }

  Future<void> setIsFirstEnter(bool setVal) async {
    _userModel.update(
      isFirstEnter: setVal,
    );
    await _authLocalStore.saveFirstEnter(setVal);
    notifyListeners();
  }

  bool isTelegramFeatureWorks = false;

  Future<void> _initializeTelegram() async {
    if (!_telegramAuthBridge.isSupported) {
      isTelegramFeatureWorks = false;
      _logger.info('telegram', 'Telegram bridge not available for current platform');
      return;
    }

    try {
      await _telegramAuthBridge.ready();
      _telegramAuthBridge.disableVerticalSwipes();
      _telegramUser = _telegramAuthBridge.user;
      isTelegramFeatureWorks = true;
      expandTelegram();
      _logger.info('telegram', 'Telegram bridge ready');

      if (_telegramUser == null) {
        _logger.warning('telegram', 'Telegram user is missing in init data');
        return;
      }

      if ((_userModel.language_code ?? '').isEmpty) {
        final tgLang = _telegramUser!.languageCode;
        if (tgLang != null && tgLang.isNotEmpty) {
          _logger.info('telegram', 'Auto-detecting language from Telegram user: $tgLang');
          _userModel.update(language_code: tgLang);
          await _authLocalStore.saveLanguageCode(tgLang);
        } else {
          _logger.info('telegram', 'Waiting for language selection before Telegram auth');
          return;
        }
      }

      await _loginWithTelegram();
    } catch (e) {
      isTelegramFeatureWorks = false;
      _logger.warning('telegram', 'Telegram initialization skipped: $e');
      ApiLogger.apiPrint('Telegram initialization skipped: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<void> expandTelegram() async {
    if (isTelegramFeatureWorks) {
      Future.delayed(const Duration(milliseconds: 10), _telegramAuthBridge.expand);
    }
  }

  Future<void> _loginWithTelegram() async {
    final initData = _telegramAuthBridge.initDataRaw;

    if (initData == null) {
      _hasError = true;
      _errorMessage = 'Init data is null';
      _logger.warning('telegram', 'Init data is missing; Telegram login skipped');
      ApiLogger.apiPrint('Init data is null');
      return;
    }

    try {
      _logger.info('telegram', 'Attempting Telegram auth');
      final response = await _authApi.loginWithTelegram(
        initData: initData,
        languageCode: userModel.language_code,
      );
      await _applyAuthenticatedUser(response.userData, response.token, fallbackEmail: null);
      _logger.info('telegram', 'Telegram auth succeeded');
      ApiLogger.apiPrint('Login with Telegram succeeded');
    } catch (e) {
      _hasError = true;
      _errorMessage = 'Error TG login: $e';
      _logger.error('telegram', _errorMessage);
      ApiLogger.apiPrint(_errorMessage);
    }
  }

  Future<void> loginWithEmail(String email, String password) async {
    _isLoading = true;
    _hasError = false;
    _errorMessage = '';
    notifyListeners();

    try {
      _logger.info('auth', 'Attempting email login');
      final response = await _authApi.loginWithEmail(email: email, password: password);
      await _applyAuthenticatedUser(response.userData, response.token, fallbackEmail: email);
      await _authLocalStore.saveLastEmail(email);
      await _authLocalStore.saveLastPassword(password);
      _logger.info('auth', 'Email login succeeded');
      ApiLogger.apiPrint('Login with email succeeded');
    } catch (e) {
      _hasError = true;
      _errorMessage = 'loginWithEmail Network error: $e';
      _logger.error('auth', _errorMessage);
      ApiLogger.apiPrint(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> registerWithEmail(String name, String email, String password, String passwordConfirmation) async {
    _isLoading = true;
    _hasError = false;
    _errorMessage = '';
    notifyListeners();

    try {
      _logger.info('auth', 'Attempting email registration');
      await _authApi.registerWithEmail(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        languageCode: _userModel.language_code,
      );
      await loginWithEmail(email, password);
      if (_userModel.token != null) {
        _logger.info('auth', 'Email registration succeeded');
        ApiLogger.apiPrint('Register with email succeeded');
      }
    } catch (e) {
      _hasError = true;
      _errorMessage = 'registerWithEmail Network error: $e';
      _logger.error('auth', _errorMessage);
      ApiLogger.apiPrint(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void retry() {
    initialize();
  }

  Future<void> saveLanguageCode(String languageCode) async {
    _userModel.update(language_code: languageCode);
    await _authLocalStore.saveLanguageCode(languageCode);
    _logger.info('auth', 'Language selected: $languageCode');

    if (_userModel.token == null && _telegramAuthBridge.isSupported) {
      _isLoading = true;
      notifyListeners();
      await _initializeTelegram();
      _isLoading = false;
    }

    notifyListeners();
  }

  Future<void> _applyAuthenticatedUser(
    Map<String, dynamic> userData,
    String token, {
    required String? fallbackEmail,
  }) async {
    if (userData['base_font_size'] != null) {
      _userModel.update(base_font_size: userData['base_font_size'].toDouble());
    }

    final resolvedEmail = userData['email'] ?? fallbackEmail;
    _userModel.update(
      apiId: userData['id'],
      telegram_id: userData['telegram_id'],
      name: userData['name'],
      email: resolvedEmail,
      tg_username: userData['tg_username'],
      tg_first_name: userData['tg_first_name'],
      tg_last_name: userData['tg_last_name'],
      tg_language_code: userData['tg_language_code'],
      language_code: userData['language_code'] ?? _userModel.language_code,
      token: token,
      authDate: userData['auth_date'],
      user_lvl: userData['user_lvl'],
    );

    if (resolvedEmail != null && resolvedEmail.isNotEmpty) {
      await _authLocalStore.saveLastEmail(resolvedEmail);
    } else {
      await _authLocalStore.clearLastEmail();
    }
  }
}
