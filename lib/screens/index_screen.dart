import 'package:flutter/material.dart';
import 'package:mindflasher_4/providers/provider_user_login.dart';
import 'package:mindflasher_4/screens/registration_screen.dart';
import 'package:mindflasher_4/screens/util/snackbar_extension.dart';
import 'package:provider/provider.dart';
import 'package:telegram_web_app/telegram_web_app.dart';
import 'package:mindflasher_4/main.dart'; // Импортируем файл с классом ProviderUserLogin
import 'login_screen.dart'; // Импортируем экран логина
import 'deck_list_screen.dart'; // Импортируем заглушку для DeckListScreen

class IndexScreen extends StatelessWidget {
  final TelegramWebApp telegram = TelegramWebApp.instance;

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<ProviderUserLogin>();
    final user = notifier.userModel;

    // Навигация на соответствующий экран
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DeckListScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    });

    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // Показ индикатора загрузки, пока происходит перенаправление
      ),
    );
  }
}
