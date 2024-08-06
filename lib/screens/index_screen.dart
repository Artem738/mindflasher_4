import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/provider_user_login.dart';
import 'deck_list_screen.dart';
import 'login_screen.dart';

class IndexScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userLoginProvider = Provider.of<ProviderUserLogin>(context);

    if (userLoginProvider.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (userLoginProvider.userModel?.token != null) {
      return DeckListScreen();
    } else {
      return LoginScreen();
    }
  }
}
