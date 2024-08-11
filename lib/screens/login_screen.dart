import 'package:flutter/material.dart';
import 'package:mindflasher_4/main.dart';
import 'package:mindflasher_4/models/user_model.dart';
import 'package:mindflasher_4/providers/provider_user_control.dart';
import 'package:mindflasher_4/providers/provider_user_login.dart';
import 'package:mindflasher_4/screens/deck_index_screen.dart';
import 'package:mindflasher_4/screens/template_deck_index_screen.dart';
import 'package:mindflasher_4/screens/user_settings_screen.dart';
import 'package:mindflasher_4/screens/registration_screen.dart'; // Импортируем экран регистрации
import 'package:mindflasher_4/services/api_logger.dart';
import 'package:mindflasher_4/translates/login_screen_translate.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(
        text: context.read<ProviderUserLogin>().userModel.email);
    _passwordController = TextEditingController(
        text: context.read<ProviderUserLogin>().lastPass);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var txt = LoginScreenTranslate(context.read<UserModel>().language_code ?? 'en');

    return Scaffold(
      appBar: AppBar(
        title: Text(txt.tt('title')),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: txt.tt('password')),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final provider = context.read<ProviderUserLogin>();
                await provider.loginWithEmail(
                  _emailController.text,
                  _passwordController.text,
                );
                if (mounted && provider.userModel.token != null) {
                  ApiLogger.apiPrint("Token after login: ${provider.userModel.token} ");
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => IndexScreen()),
                  );
                } else {
                  if (mounted) {
                    ApiLogger.apiPrint("Login failed: ${provider.userModel.token} ");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(txt.tt('login_failed'))),
                    );
                  }
                }
              },
              child: Text(txt.tt('login')),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistrationScreen()),
                );
              },
              child: Text(txt.tt('register')),
            ),
          ],
        ),
      ),
    );
  }
}
