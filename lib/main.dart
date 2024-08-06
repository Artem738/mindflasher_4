import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'providers/provider_user_control.dart';
import 'providers/provider_user_login.dart';
import 'screens/deck_list_screen.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProviderUserLogin()),
        ChangeNotifierProvider(create: (_) => ProviderUserControl()),
        // Добавь другие провайдеры здесь
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
      home: IndexScreen(),
    );
  }
}

class IndexScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userLoginProvider = Provider.of<ProviderUserLogin>(context);
    final userControlProvider = Provider.of<ProviderUserControl>(context);

    if (userLoginProvider.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (userLoginProvider.hasError) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(userLoginProvider.errorMessage)),
        );
      });
      return LoginScreen(); // Возвращаем экран логина, если произошла ошибка
    }

    if (userLoginProvider.userModel?.token != null) {
      // Отложенный вызов initializeUser
      SchedulerBinding.instance.addPostFrameCallback((_) {
        userControlProvider.initializeUser(userLoginProvider.userModel!);
      });
      return DeckListScreen();
    } else {
      return LoginScreen();
    }
  }
}
