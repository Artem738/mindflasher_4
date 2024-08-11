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

class LoginScreen extends StatelessWidget {
  late TextEditingController _emailController = TextEditingController();
  late TextEditingController _passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {

    //final providerUserLogin = context.watch<ProviderUserLogin>().userModel;
    _emailController = TextEditingController(text: context.watch<ProviderUserLogin>().userModel.email);
    _passwordController = TextEditingController(text: context.watch<ProviderUserLogin>().lastPass);
    var txt = LoginScreenTranslate(context.read<UserModel>().languageCode ?? 'uk');
// Text(txt.tr('add_deck_prompt')),
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
                if (provider.userModel.token != null) {
                  ApiLogger.apiPrint("Token after login: ${provider.userModel.token} ");
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => IndexScreen()),
                    //MaterialPageRoute(builder: (context) => TemplateDeckIndexScreen()),
                  );
                } else {
                  ApiLogger.apiPrint("Login failed: ${provider.userModel.token} ");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(txt.tt('login_failed'))),
                  );
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
