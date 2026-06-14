import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mindflasher_4/env_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalState {
  const AuthLocalState({
    required this.isPreferencesAvailable,
    required this.isFirstEnter,
    this.lastEmail,
    this.languageCode,
    this.lastPassword = '',
    this.themeMode,
  });

  final bool isPreferencesAvailable;
  final bool isFirstEnter;
  final String? lastEmail;
  final String? languageCode;
  final String lastPassword;
  final String? themeMode;
}

abstract class AuthLocalStore {
  Future<AuthLocalState> load();

  Future<void> saveFirstEnter(bool value);

  Future<void> saveLanguageCode(String value);

  Future<void> saveLastEmail(String value);

  Future<void> clearLastEmail();

  Future<void> saveLastPassword(String value);

  Future<void> saveThemeMode(String value);
}

class DeviceAuthLocalStore implements AuthLocalStore {
  DeviceAuthLocalStore({
    SharedPreferences? sharedPreferences,
    FlutterSecureStorage? secureStorage,
    bool? useSecureStorage,
  })  : _sharedPreferences = sharedPreferences,
        _secureStorage = secureStorage,
        _useSecureStorage = useSecureStorage ?? !kIsWeb;

  static const String firstEnterKey = 'firstEnter_${EnvConfig.StorageAndSharedPreferencesKey}';
  static const String lastEmailKey = 'lastEmail_${EnvConfig.StorageAndSharedPreferencesKey}';
  static const String languageCodeKey = 'language_${EnvConfig.StorageAndSharedPreferencesKey}';
  static const String lastPasswordKey = 'lastPass_${EnvConfig.StorageAndSharedPreferencesKey}';
  static const String themeModeKey = 'themeMode_${EnvConfig.StorageAndSharedPreferencesKey}';

  SharedPreferences? _sharedPreferences;
  FlutterSecureStorage? _secureStorage;
  final bool _useSecureStorage;

  Future<SharedPreferences> _getSharedPreferences() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
    return _sharedPreferences!;
  }

  Future<FlutterSecureStorage?> _getSecureStorage() async {
    if (!_useSecureStorage) {
      return null;
    }

    _secureStorage ??= const FlutterSecureStorage();
    return _secureStorage;
  }

  @override
  Future<AuthLocalState> load() async {
    try {
      final preferences = await _getSharedPreferences();
      final firstEnter = preferences.getBool(firstEnterKey);
      final resolvedFirstEnter = firstEnter ?? true;

      if (firstEnter == null) {
        await preferences.setBool(firstEnterKey, true);
      }

      final secureStorage = await _getSecureStorage();
      final lastPassword = secureStorage == null
          ? ''
          : await secureStorage.read(key: lastPasswordKey) ?? '';

      return AuthLocalState(
        isPreferencesAvailable: true,
        isFirstEnter: resolvedFirstEnter,
        lastEmail: preferences.getString(lastEmailKey),
        languageCode: preferences.getString(languageCodeKey),
        lastPassword: lastPassword,
        themeMode: preferences.getString(themeModeKey),
      );
    } catch (_) {
      final secureStorage = await _getSecureStorage();
      final lastPassword = secureStorage == null
          ? ''
          : await secureStorage.read(key: lastPasswordKey) ?? '';

      return AuthLocalState(
        isPreferencesAvailable: false,
        isFirstEnter: true,
        lastPassword: lastPassword,
      );
    }
  }

  @override
  Future<void> saveFirstEnter(bool value) async {
    try {
      final preferences = await _getSharedPreferences();
      await preferences.setBool(firstEnterKey, value);
    } catch (_) {
    }
  }

  @override
  Future<void> saveLanguageCode(String value) async {
    try {
      final preferences = await _getSharedPreferences();
      await preferences.setString(languageCodeKey, value);
    } catch (_) {
    }
  }

  @override
  Future<void> saveThemeMode(String value) async {
    try {
      final preferences = await _getSharedPreferences();
      await preferences.setString(themeModeKey, value);
    } catch (_) {
    }
  }

  @override
  Future<void> saveLastEmail(String value) async {
    try {
      final preferences = await _getSharedPreferences();
      await preferences.setString(lastEmailKey, value);
    } catch (_) {
    }
  }

  @override
  Future<void> clearLastEmail() async {
    try {
      final preferences = await _getSharedPreferences();
      await preferences.remove(lastEmailKey);
    } catch (_) {
    }
  }

  @override
  Future<void> saveLastPassword(String value) async {
    final secureStorage = await _getSecureStorage();
    if (secureStorage == null) {
      return;
    }

    await secureStorage.write(key: lastPasswordKey, value: value);
  }
}