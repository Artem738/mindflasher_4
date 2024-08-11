import 'package:flutter/material.dart';
import 'package:mindflasher_4/screens/language_selection_screen.dart';
import 'package:mindflasher_4/screens/test_info_screen.dart';
import 'package:mindflasher_4/screens/tg_test_info_screen.dart';
import 'package:provider/provider.dart';
import '../providers/provider_user_control.dart';

class UserSettingsScreen extends StatefulWidget {
  @override
  _UserSettingsScreenState createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserSettingsScreen> {
  final List<String> _inputSequence = [];
  DateTime _lastPressTime = DateTime.now();
  final int _timeoutDuration = 3; // Таймаут в секундах

  void _handleLongPress(BuildContext context) {
    final currentTime = DateTime.now();
    final difference = currentTime.difference(_lastPressTime).inSeconds;

    if (difference > _timeoutDuration) {
      _inputSequence.clear();
    }

    setState(() {
      _inputSequence.add('-');
    });
    print('Long press detected: ${_inputSequence.join('')}');
    _lastPressTime = currentTime;
    _checkSequence(context);
  }

  void _handleShortPress(BuildContext context) {
    final currentTime = DateTime.now();
    final difference = currentTime.difference(_lastPressTime).inSeconds;

    if (difference > _timeoutDuration) {
      _inputSequence.clear();
    }

    setState(() {
      _inputSequence.add('*');
    });
    print('Short press detected: ${_inputSequence.join('')}');
    _lastPressTime = currentTime;
    _checkSequence(context);
  }

  void _checkSequence(BuildContext context) {
    final targetSequence = ['-', '-', '-', '-', '*', '*', '*', '*', '*', '*', '*', '*'];

    if (_inputSequence.length == targetSequence.length) {
      bool isMatch = true;
      for (int i = 0; i < _inputSequence.length; i++) {
        if (_inputSequence[i] != targetSequence[i]) {
          isMatch = false;
          break;
        }
      }

      if (isMatch) {
        // Если последовательность совпала, ждем таймаут
        Future.delayed(Duration(seconds: _timeoutDuration), () {
          final currentTime = DateTime.now();
          final difference = currentTime.difference(_lastPressTime).inSeconds;

          // Проверяем, что прошло время таймаута
          if (difference >= _timeoutDuration) {
            _inputSequence.clear();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => TestInfoScreen(),
              ),
            );
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userModel = context.watch<ProviderUserControl>().userModel;

    return Scaffold(
      appBar: AppBar(
        title: Text('User Settings Screen '),
      ),
      body: GestureDetector(
        onLongPress: () => _handleLongPress(context),
        onTap: () => _handleShortPress(context),
        child: Center(
          child: Container(
            padding: EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome ${userModel.tg_first_name ?? userModel.tg_username ?? ''}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
                ),
                Text('apiId: ${userModel.apiId ?? ''}'),
                Text('Name: ${userModel.name ?? ''}'),
                Text('Username: ${userModel.tg_username ?? ''}'),
                Text('Email: ${userModel.email ?? ''}'),
                Text('Telegram ID: ${userModel.telegram_id ?? ''}'),
                Text('Фамилия: ${userModel.tg_last_name ?? ''}'),
                Text('Telegram Язык: ${userModel.tg_language_code ?? ''}'),
                Text('Язык: ${userModel.language_code ?? ''}'),
                Text('Уровень : ${userModel.user_lvl ?? ''}'),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LanguageSelectionScreen()),
                    );
                    //context.read<ProviderUserControl>().updateUserLanguageCode(userModel.token!, 'en');
                  },
                  child: Text('Change Lang'),
                ),
                SizedBox(
                  height: 10,
                ),
                // ElevatedButton(
                //   onPressed: () {
                //     // Navigator.pushReplacement(
                //     //   context,
                //     //   MaterialPageRoute(builder: (context) => TgTestInfoScreen()),
                //     // );
                //     //context.read<ProviderUserControl>().updateUserLanguageCode(userModel.token!, 'en');
                //   },
                //   child: Text('Test Telegram'),
                // ),
                Text(
                  _inputSequence.join(' '),
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
