import 'package:flutter/material.dart';
import 'package:mindflasher_4/main.dart';
import 'package:mindflasher_4/models/user_model.dart';
import 'package:mindflasher_4/providers/provider_user_control.dart';
import 'package:mindflasher_4/providers/provider_user_login.dart';
import 'package:mindflasher_4/screens/deck/deck_index_screen.dart';
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
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.flash_on_rounded,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: txt.tt('password'),
                  prefixIcon: const Icon(Icons.lock_outline),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: () async {
                  final provider = context.read<ProviderUserLogin>();
                  await provider.loginWithEmail(
                    _emailController.text,
                    _passwordController.text,
                  );
                  if (mounted && provider.userModel.token != null) {
                    ApiLogger.apiPrint('Login screen redirect after successful email auth');
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => IndexScreen()),
                    );
                  } else {
                    if (mounted) {
                      ApiLogger.apiPrint('Login screen shows authentication error');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(txt.tt('login_failed')),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  }
                },
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  txt.tt('login'),
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegistrationScreen()),
                  );
                },
                child: Text(
                  txt.tt('register'),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
