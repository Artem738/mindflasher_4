import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mindflasher_4/providers/auth_provider.dart';

class TelegramLoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Telegram Login'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            authProvider.loginWithTelegram();
          },
          child: Text('Login with Telegram'),
        ),
      ),
    );
  }
}
