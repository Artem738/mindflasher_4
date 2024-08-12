import 'package:flutter/material.dart';
import 'package:mindflasher_4/screens/font_size_adjustment_screen.dart';
import 'package:mindflasher_4/screens/language_selection_screen.dart';
import 'package:mindflasher_4/screens/tap_code_screen.dart'; // Добавлен новый экран
import 'package:provider/provider.dart';
import '../providers/provider_user_control.dart';

class UserSettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userControl = context.watch<ProviderUserControl>();
    final userModel = userControl.userModel;

    return Scaffold(
      appBar: AppBar(
        title: Text('User Settings Screen'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome ${userModel.tg_first_name ?? userModel.name ?? ''}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
              ),
              Text('apiId: ${userModel.apiId ?? ''}'),
              Text('Telegram ID: ${userModel.telegram_id ?? ''}'),
              Text('Name: ${userModel.name ?? ''}'),
              Text('Username: ${userModel.tg_username ?? ''}'),
              Text('Email: ${userModel.email ?? ''}'),
              Text('Фамилия: ${userModel.tg_last_name ?? ''}'),
              Text('Telegram Язык: ${userModel.tg_language_code ?? ''}'),
              Text('Язык: ${userModel.language_code ?? ''}'),
              Text('Уровень : ${userModel.user_lvl ?? ''}'),
              Text('Размер шрифта : ${userModel.base_font_size  ?? ''}'),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FontSizeAdjustmentScreen(),
                    ),
                  );
                },
                child: Text('Изменить размер шрифта', style: TextStyle(fontSize: 20)),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LanguageSelectionScreen()),
                  );
                },
                child: Text('Change Lang', style: TextStyle(fontSize: 20)),
              ),
              SizedBox(height: 20),
              // ElevatedButton(
              //   onPressed: () {
              //     Navigator.pushReplacement(
              //       context,
              //       MaterialPageRoute(builder: (context) => TapCodeScreen()),
              //     );
              //   },
              //   child: Text('Test Screen'),
              // ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TapCodeScreen()),
                  );
                },
                child: Text('Tap Code Screen', style: TextStyle(fontSize: 20)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
