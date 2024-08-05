import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mindflasher_4/env_config.dart';
import 'package:mindflasher_4/providers/provider_user_login.dart';
import 'package:mindflasher_4/screens/test_info_screen.dart';
import 'package:mindflasher_4/models/user_model.dart';
import 'package:mindflasher_4/screens/util/snackbar_extension.dart';
import 'package:mindflasher_4/services/api_logger.dart';
import 'package:mindflasher_4/telegram/telegram_utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telegram_web_app/telegram_web_app.dart';
import 'package:http/http.dart' as http;

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
          : ScaffoldMessenger(
        child: TestInfoScreen(), // Убедимся, что класс MainApp объявлен корректно
      ),
    );
  }
}


