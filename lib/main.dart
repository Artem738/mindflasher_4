import 'package:flutter/material.dart';
import 'package:mindflasher_4/providers/deck_provider.dart';
import 'package:mindflasher_4/providers/flashcard_provider.dart';
import 'package:mindflasher_4/providers/template_deck_provider.dart';
import 'package:mindflasher_4/providers/template_flashcard_provider.dart';
import 'package:mindflasher_4/screens/deck_index_screen.dart';
import 'package:mindflasher_4/screens/first_enter_screen.dart';
import 'package:mindflasher_4/screens/language_selection_screen.dart';
import 'package:mindflasher_4/screens/template_deck_index_screen.dart';
import 'package:mindflasher_4/services/api_logger.dart';
import 'package:provider/provider.dart';
import 'providers/provider_user_control.dart';
import 'providers/provider_user_login.dart';
import 'screens/user_settings_screen.dart';
import 'screens/login_screen.dart';
import 'models/user_model.dart';

void main() {
  final userModel = UserModel();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: userModel),
        ChangeNotifierProxyProvider<UserModel, ProviderUserLogin>(
          create: (context) => ProviderUserLogin(userModel),
          update: (context, userModel, providerUserLogin) => providerUserLogin!,
        ),
        ChangeNotifierProxyProvider<UserModel, ProviderUserControl>(
          create: (context) => ProviderUserControl(userModel),
          update: (context, userModel, providerUserControl) => providerUserControl!,
        ),
        ChangeNotifierProvider(create: (_) => TemplateDeckProvider()),
        ChangeNotifierProvider(create: (_) => TemplateFlashcardProvider()),
        ChangeNotifierProvider(create: (_) => DeckProvider()),
        ChangeNotifierProvider(create: (_) => FlashcardProvider()),
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
    final userModel = Provider.of<UserModel>(context);
    final userLogin = context.watch<ProviderUserLogin>();

    if (userLogin.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (userLogin.hasError) {
      ApiLogger.apiPrint("Error with login: ${userLogin.errorMessage}");
    }

    if (userModel.language_code == null && userLogin.isLoading == false) {
      // Если languageCode отсутствует, показываем экран выбора языка
      return LanguageSelectionScreen();
    }


    if (userModel.token == null && userLogin.isLoading == false) {
      return LoginScreen();
    } else {
      if (userModel.isFirstEnter == true) {
        // Если languageCode отсутствует, показываем экран выбора языка
        return FirstEnterScreen();
      } else {
        return DeckIndexScreen();
        //return TemplateDeckIndexScreen();
      }

    }
  }
}
