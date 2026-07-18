import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindflasher_4/models/user_model.dart';
import 'package:mindflasher_4/providers/provider_user_login.dart';
import 'package:mindflasher_4/services/auth/auth_api.dart';
import 'package:mindflasher_4/services/auth/auth_local_store.dart';
import 'package:mindflasher_4/services/auth/telegram_auth_bridge.dart';
import 'package:mindflasher_4/services/logging/app_logger.dart';

class FakeAuthLocalStore implements AuthLocalStore {
  FakeAuthLocalStore({required this.initialState});

  final AuthLocalState initialState;
  bool? savedFirstEnter;
  String? savedLanguageCode;
  String? savedLastEmail;
  String? savedLastPassword;
  String? savedThemeMode;
  bool clearedLastEmail = false;

  @override
  Future<void> clearLastEmail() async {
    clearedLastEmail = true;
  }

  @override
  Future<AuthLocalState> load() async => initialState;

  @override
  Future<void> saveFirstEnter(bool value) async {
    savedFirstEnter = value;
  }

  @override
  Future<void> saveLanguageCode(String value) async {
    savedLanguageCode = value;
  }

  @override
  Future<void> saveLastEmail(String value) async {
    savedLastEmail = value;
  }

  @override
  Future<void> saveLastPassword(String value) async {
    savedLastPassword = value;
  }

  @override
  Future<void> saveThemeMode(String value) async {
    savedThemeMode = value;
  }

  String? savedToken;
  bool clearedToken = false;

  @override
  Future<void> saveToken(String value) async {
    savedToken = value;
  }

  @override
  Future<void> clearToken() async {
    clearedToken = true;
  }
}

class FakeAuthApi implements AuthApi {
  FakeAuthApi({this.emailLoginResponse, this.telegramLoginResponse});

  final AuthApiResponse? emailLoginResponse;
  final AuthApiResponse? telegramLoginResponse;
  String? registeredLanguageCode;
  String? lastTelegramInitData;
  String? lastTelegramLanguageCode;

  @override
  Future<AuthApiResponse> loginWithEmail({required String email, required String password}) async {
    return emailLoginResponse!;
  }

  @override
  Future<AuthApiResponse> loginWithTelegram({required String initData, required String? languageCode}) async {
    lastTelegramInitData = initData;
    lastTelegramLanguageCode = languageCode;
    return telegramLoginResponse!;
  }

  @override
  Future<void> registerWithEmail({required String name, required String email, required String password, required String passwordConfirmation, required String? languageCode}) async {
    registeredLanguageCode = languageCode;
  }

  @override
  Future<AuthApiResponse> loginWithWebKey({required String key}) async {
    throw UnimplementedError('FakeAuthApi.loginWithWebKey is not implemented');
  }
}

class FakeTelegramAuthBridge implements TelegramAuthBridge {
  FakeTelegramAuthBridge({
    required this.isSupported,
    this.raw,
    this.telegramUser,
  });

  @override
  final bool isSupported;

  int readyCalls = 0;
  int expandCalls = 0;
  final String? raw;
  final TelegramUser? telegramUser;

  @override
  String? get initDataRaw => raw;

  @override
  TelegramUser? get user => telegramUser;

  @override
  Future<void> ready() async {
    readyCalls += 1;
  }

  @override
  void expand() {
    expandCalls += 1;
  }

  @override
  void disableVerticalSwipes() {}
}

void main() {
  group('ProviderUserLogin', () {
    test('initialize hydrates user model from local state', () async {
      final userModel = UserModel();
      final localStore = FakeAuthLocalStore(
        initialState: const AuthLocalState(
          isPreferencesAvailable: true,
          isFirstEnter: false,
          lastEmail: 'stored@example.com',
          languageCode: 'uk',
          lastPassword: 'pw',
        ),
      );
      final provider = ProviderUserLogin(
        userModel,
        authApi: FakeAuthApi(),
        authLocalStore: localStore,
        logger: AppLogger.instance,
        autoInitialize: false,
      );

      await provider.initialize();

      expect(provider.isLoading, isFalse);
      expect(provider.isLocalPreferencesAvailable, isTrue);
      expect(provider.lastPass, 'pw');
      expect(userModel.email, 'stored@example.com');
      expect(userModel.language_code, 'uk');
      expect(userModel.isFirstEnter, isFalse);
    });

    test('loginWithEmail updates user model and saves credentials', () async {
      final userModel = UserModel(language_code: 'en');
      final localStore = FakeAuthLocalStore(
        initialState: const AuthLocalState(
          isPreferencesAvailable: true,
          isFirstEnter: true,
        ),
      );
      final provider = ProviderUserLogin(
        userModel,
        authApi: FakeAuthApi(
          emailLoginResponse: const AuthApiResponse(
            token: 'access-token',
            userData: {
              'id': 42,
              'name': 'Artem',
              'email': 'artem@example.com',
              'user_lvl': 1,
              'telegram_id': null,
              'tg_username': null,
              'tg_first_name': null,
              'tg_last_name': null,
              'tg_language_code': null,
              'language_code': 'en',
              'base_font_size': 18,
            },
          ),
        ),
        authLocalStore: localStore,
        logger: AppLogger.instance,
        autoInitialize: false,
      );

      await provider.loginWithEmail('artem@example.com', 'secret');

      expect(userModel.token, 'access-token');
      expect(userModel.name, 'Artem');
      expect(userModel.base_font_size, 18);
      expect(localStore.savedLastEmail, 'artem@example.com');
      expect(localStore.savedLastPassword, 'secret');
    });

    test('saveLanguageCode updates model and local storage', () async {
      final userModel = UserModel();
      final localStore = FakeAuthLocalStore(
        initialState: const AuthLocalState(
          isPreferencesAvailable: true,
          isFirstEnter: true,
        ),
      );
      final provider = ProviderUserLogin(
        userModel,
        authApi: FakeAuthApi(),
        authLocalStore: localStore,
        logger: AppLogger.instance,
        autoInitialize: false,
      );

      await provider.saveLanguageCode('ru');

      expect(userModel.language_code, 'ru');
      expect(localStore.savedLanguageCode, 'ru');
    });

    test('saveLanguageCode resumes Telegram auth when bridge is available', () async {
      final userModel = UserModel();
      final localStore = FakeAuthLocalStore(
        initialState: const AuthLocalState(
          isPreferencesAvailable: true,
          isFirstEnter: true,
        ),
      );
      final authApi = FakeAuthApi(
        telegramLoginResponse: const AuthApiResponse(
          token: 'tg-token',
          userData: {
            'id': 7,
            'name': 'Telegram User',
            'email': null,
            'user_lvl': 1,
            'telegram_id': 99,
            'tg_username': 'tg_name',
            'tg_first_name': 'Telegram',
            'tg_last_name': 'User',
            'tg_language_code': 'en',
            'language_code': 'uk',
            'base_font_size': 16,
          },
        ),
      );
      final provider = ProviderUserLogin(
        userModel,
        authApi: authApi,
        authLocalStore: localStore,
        telegramAuthBridge: FakeTelegramAuthBridge(
          isSupported: true,
          raw: 'telegram-init-data',
          telegramUser: TelegramUser(),
        ),
        logger: AppLogger.instance,
        autoInitialize: false,
      );

      await provider.saveLanguageCode('uk');

      expect(authApi.lastTelegramInitData, 'telegram-init-data');
      expect(authApi.lastTelegramLanguageCode, 'uk');
      expect(userModel.token, 'tg-token');
    });

    test('saveThemeMode updates model and local storage', () async {
      final userModel = UserModel();
      final localStore = FakeAuthLocalStore(
        initialState: const AuthLocalState(
          isPreferencesAvailable: true,
          isFirstEnter: true,
        ),
      );
      final provider = ProviderUserLogin(
        userModel,
        authApi: FakeAuthApi(),
        authLocalStore: localStore,
        logger: AppLogger.instance,
        autoInitialize: false,
      );

      await provider.saveThemeMode(ThemeMode.dark);

      expect(userModel.themeMode, ThemeMode.dark);
      expect(localStore.savedThemeMode, 'dark');

      await provider.saveThemeMode(ThemeMode.system);
      expect(userModel.themeMode, ThemeMode.system);
      expect(localStore.savedThemeMode, 'system');
    });
  });
}
