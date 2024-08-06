import 'package:flutter/material.dart';
import 'package:mindflasher_4/providers/provider_user_login.dart';
import 'package:mindflasher_4/screens/deck_list_screen.dart';
import 'package:mindflasher_4/screens/registration_screen.dart'; // Импортируем экран регистрации
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
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
              decoration: InputDecoration(labelText: 'Password'),
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
                if (provider.userModel != null) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => DeckListScreen()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Login failed')),
                  );
                }
              },
              child: Text('Login'),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistrationScreen()),
                );
              },
              child: Text('Don\'t have an account? Register'),
            ),
          ],
        ),
      ),
    );
  }
}
