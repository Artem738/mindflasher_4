import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mindflasher_4/env_config.dart';
import 'package:mindflasher_4/models/user_model.dart';
import 'package:mindflasher_4/services/api_logger.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telegram_web_app/telegram_web_app.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProviderUserLogin()),
      ],
      child: AppStartupWidget(),
    ),
  );
}

class AppStartupWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<ProviderUserLogin>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: notifier.isLoading
          ? Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : MainApp(),
    );
  }
}

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

          await _loginWithTelegram();
        }
      }
    } catch (e) {
      // Игнорируем ошибку, так как это нормальное поведение
    }

    if (_telegramUser == null) {
      await _loginWithoutTelegram();
    }
  }


  Future<void> _loginWithTelegram() async {
    const url = '${EnvConfig.mainApiUrl}/telegram/auth';
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode(_userModel?.toJson());

    try {
      final response = await http.post(Uri.parse(url), headers: headers, body: body);
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        // Обработка успешного ответа, например, сохранение токена
        _userModel = _userModel?.copyWith(token: responseData['token']);
        notifyListeners();
      } else {
        // Обработка ошибки
        _hasError = true;
        _errorMessage = 'Ошибка авторизации: ${response.statusCode}';
        notifyListeners();
      }
    } catch (e) {
      // Обработка ошибки сети
      _hasError = true;
      _errorMessage = 'Ошибка сети: $e';
      notifyListeners();
    }
  }

  Future<void> _loginWithoutTelegram() async {
    // Здесь будет логика для взаимодействия с сервером
    ApiLogger.apiPrint('Logged in without Telegram');
  }

  void retry() {
    _isLoading = true;
    _hasError = false;
    _errorMessage = '';
    initialize();
    notifyListeners();
  }
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<ProviderUserLogin>();
    // notifier.initialize();
    final sharedPreferences = notifier.sharedPreferences;
    final user = context.read<ProviderUserLogin>()._userModel;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Main App 2'),
        ),
        body: Center(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (user != null) ...[
                  Text('Logged in via Telegram'),
                  Text('User ID: ${user.tgId}'),
                  Text('First Name: ${user.firstname}'),
                  if (user.lastname != null) Text('Last Name: ${user.lastname}'),
                  if (user.username != null) Text('Username: ${user.username}'),
                  if (user.languageCode != null) Text('Language Code: ${user.languageCode}'),
                ] else
                  Text('Simple login'),
                Text('SharedPreferences is ready: ${sharedPreferences != null}'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
