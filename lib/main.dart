import 'package:flutter/material.dart';
import 'package:mindflasher_4/services/api_logger.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telegram_web_app/telegram_web_app.dart';

void main() {
  ApiLogger.apiPrint('App Startup');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppStartupNotifier()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AppStartupWidget(),
    );
  }
}

class AppStartupWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<AppStartupNotifier>(context);
    //notifier.initialize();
    if (notifier.isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return MainApp();
    }
  }
}

class AppStartupNotifier extends ChangeNotifier {
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  SharedPreferences? _sharedPreferences;
  TelegramUser? _telegramUser;

  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
  SharedPreferences? get sharedPreferences => _sharedPreferences;
  TelegramUser? get telegramUser => _telegramUser;

  AppStartupNotifier() {
    //ApiLogger.apiPrint('AppStartupNotifier Constructor Called');
    initialize();
  }

  Future<void> initialize() async {
    try {
      if (TelegramWebApp.instance.isSupported) {
        await TelegramWebApp.instance.ready();
        _telegramUser = TelegramWebApp.instance.initData?.user;
        Future.delayed(const Duration(seconds: 1), TelegramWebApp.instance.expand);
        if (_telegramUser != null) {
          await _loginWithTelegram(_telegramUser!);
        }
      }
    } catch (e) {
      //ApiLogger.apiPrint("Error happened in Flutter while loading Telegram $e");
    }

    try {
      if (_telegramUser == null) {
        await _loginWithoutTelegram();
      }

      _sharedPreferences = await SharedPreferences.getInstance();
    } catch (e) {
      _hasError = true;
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loginWithTelegram(TelegramUser user) async {
    // Заглушка метода для авторизации через Telegram
    // Здесь будет логика для взаимодействия с сервером
    //await Future.delayed(Duration(seconds: 0));
    ApiLogger.apiPrint('Logged in with Telegram: ${user.username}');
  }

  Future<void> _loginWithoutTelegram() async {
    // Заглушка метода для обычной авторизации
    // Здесь будет логика для взаимодействия с сервером
   // await Future.delayed(Duration(seconds: 0));
    ApiLogger.apiPrint('Logged in without Telegram');
  }

  void retry() {
    _isLoading = true;
    _hasError = false;
    _errorMessage = '';
    notifyListeners();
    initialize();
  }
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<AppStartupNotifier>();
    // notifier.initialize();
    final sharedPreferences = notifier.sharedPreferences;
    final telegramUser = notifier.telegramUser;
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
                if (telegramUser != null) ...[
                  Text('Logged in via Telegram'),
                  Text('User ID: ${telegramUser.id}'),
                  Text('First Name: ${telegramUser.firstname}'),
                  if (telegramUser.lastname != null) Text('Last Name: ${telegramUser.lastname}'),
                  if (telegramUser.username != null) Text('Username: ${telegramUser.username}'),
                  if (telegramUser.languageCode != null) Text('Language Code: ${telegramUser.languageCode}'),
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


