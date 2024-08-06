import 'package:flutter/material.dart';
import 'package:mindflasher_4/env_config.dart';
import 'package:mindflasher_4/providers/provider_user_login.dart';
import 'package:mindflasher_4/screens/index_screen.dart';
import 'package:mindflasher_4/screens/test_info_screen.dart';
import 'package:provider/provider.dart';


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
        child: IndexScreen(), // Убедимся, что класс MainApp объявлен корректно
      ),
    );
  }
}


