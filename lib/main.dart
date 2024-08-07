import 'package:flutter/material.dart';
import 'package:mindflasher_4/services/api_logger.dart';
import 'package:provider/provider.dart';
import 'providers/provider_user_control.dart';
import 'providers/provider_user_login.dart';
import 'screens/deck_list_screen.dart';
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
      ApiLogger.apiPrint("Error: ${userLogin.errorMessage}");
    }

    if (userModel.token == null && userLogin.isLoading == false) {
      return LoginScreen();
    } else {
      return DeckListScreen();
    }
  }
}
