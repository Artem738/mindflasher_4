import 'package:flutter/material.dart';
import 'package:mindflasher_4/app/app_bootstrap_route.dart';
import 'package:mindflasher_4/providers/deck_provider.dart';
import 'package:mindflasher_4/providers/flashcard_provider.dart';
import 'package:mindflasher_4/providers/template_deck_provider.dart';
import 'package:mindflasher_4/providers/template_flashcard_provider.dart';
import 'package:mindflasher_4/screens/deck/deck_index_screen.dart';
import 'package:mindflasher_4/screens/language_selection_screen.dart';
import 'package:provider/provider.dart';
import 'providers/provider_user_control.dart';
import 'providers/provider_user_login.dart';
import 'screens/login_screen.dart';
import 'models/user_model.dart';
import 'package:mindflasher_4/services/app_http_client.dart';

void main() {
  final userModel = UserModel();

  AppHttpClient.onUnauthorized = () {
    userModel.logout();
  };

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
        ChangeNotifierProxyProvider<UserModel, TemplateDeckProvider>(
          create: (_) => TemplateDeckProvider(userModel),
          update: (_, userModel, provider) {
            provider!.updateUserModel(userModel);
            return provider;
          },
        ),
        ChangeNotifierProxyProvider<UserModel, TemplateFlashcardProvider>(
          create: (_) => TemplateFlashcardProvider(userModel),
          update: (_, userModel, provider) {
            provider!.updateUserModel(userModel);
            return provider;
          },
        ),
        ChangeNotifierProxyProvider<UserModel, DeckProvider>(
          create: (_) => DeckProvider(userModel),
          update: (_, userModel, provider) {
            provider!.updateUserModel(userModel);
            return provider;
          },
        ),
        ChangeNotifierProxyProvider<UserModel, FlashcardProvider>(
          create: (_) => FlashcardProvider(userModel),
          update: (_, userModel, provider) {
            provider!.updateUserModel(userModel);
            return provider;
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<UserModel>().themeMode;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.deepPurple.withOpacity(0.05),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.deepPurple.withOpacity(0.05),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
      home: const AppBootstrapScreen(),
    );
  }
}

class AppBootstrapScreen extends StatelessWidget {
  const AppBootstrapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userModel = Provider.of<UserModel>(context);
    final userLogin = context.watch<ProviderUserLogin>();
    final route = resolveAppBootstrapRoute(
      isLoading: userLogin.isLoading,
      languageCode: userModel.language_code,
      token: userModel.token,
    );

    switch (route) {
      case AppBootstrapRoute.loading:
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      case AppBootstrapRoute.languageSelection:
        return const LanguageSelectionScreen();
      case AppBootstrapRoute.login:
        return const LoginScreen();
      case AppBootstrapRoute.decks:
        return const DeckIndexScreen();
    }
  }
}

typedef IndexScreen = AppBootstrapScreen;
