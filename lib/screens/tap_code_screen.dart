import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mindflasher_4/env_config.dart';
import 'package:mindflasher_4/providers/provider_user_control.dart';
import 'package:mindflasher_4/screens/font_size_adjustment_screen.dart';
import 'package:mindflasher_4/screens/language_selection_screen.dart';
import 'package:mindflasher_4/screens/test_info_screen.dart';
import 'package:mindflasher_4/translates/font_size_adjustment_screen.dart';
import 'package:mindflasher_4/translates/special_screen_translate.dart';
import 'package:provider/provider.dart';

class TapCodeScreen extends StatefulWidget {
  @override
  _TapCodeScreenState createState() => _TapCodeScreenState();
}

class _TapCodeScreenState extends State<TapCodeScreen> {
  String _inputSequence = '';
  DateTime _lastPressTime = DateTime.now();
  final int _pauseDuration = 2; // Таймаут для паузы в секундах
  final int _resetDuration = 5; // Таймаут для сброса в секундах
  Timer? _pauseTimer;
  Timer? _resetTimer;


  // Добавляем словарь с ключами и соответствующими страницами
  final Map<String, Widget> _sequences = {
    EnvConfig.ptnHlo: TestInfoScreen(), // Это оригинальная страница
    EnvConfig.code2: LanguageSelectionScreen(), // Добавьте свой экран
    EnvConfig.code3: FontSizeAdjustmentScreen(), // Добавьте свой экран
  };

  void _processInput(BuildContext context, String signal) {
    _pauseTimer?.cancel(); // Останавливаем предыдущий таймер паузы
    _resetTimer?.cancel(); // Останавливаем предыдущий таймер сброса
    final currentTime = DateTime.now();
    final difference = currentTime.difference(_lastPressTime).inSeconds;

    // Если прошло больше времени чем таймаут паузы, добавляем паузу перед сигналом
    if (difference > _pauseDuration && _inputSequence.isNotEmpty) {
      setState(() {
        _inputSequence += '_'; // добавляем паузу
      });
    }

    setState(() {
      _inputSequence += signal; // добавляем сигнал ('-' или '*')
    });

    //print('Input detected: $_inputSequence');
    _lastPressTime = currentTime;

    // Запускаем таймер для отслеживания паузы
    _pauseTimer = Timer(Duration(seconds: _pauseDuration), () {
      setState(() {
        _inputSequence += '_'; // добавляем паузу, если таймер сработал
      });
     // print('Pause detected: $_inputSequence');
      _checkSequence(context); // Проверяем последовательность после добавления паузы
    });

    // Запускаем таймер для сброса ввода, если прошло 6 секунд
    _resetTimer = Timer(Duration(seconds: _resetDuration), () {
      setState(() {
        _inputSequence = ''; // сбрасываем последовательность
      });
     // print('Input sequence reset due to timeout');
    });

    _checkSequence(context);
  }

  void _handleLongPress(BuildContext context) {
    _processInput(context, '-');
  }

  void _handleShortPress(BuildContext context) {
    _processInput(context, '*');
  }

  void _checkSequence(BuildContext context) {
    for (var sequence in _sequences.keys) {
      if (_inputSequence.endsWith(sequence)) {
        _pauseTimer?.cancel(); // Останавливаем таймер паузы
        _resetTimer?.cancel(); // Останавливаем таймер сброса
        _inputSequence = ''; // Очистка ввода после совпадения
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => _sequences[sequence]!,
          ),
        );
        break; // Выходим из цикла после первого совпадения
      }
    }
  }



  @override
  void dispose() {
    _pauseTimer?.cancel(); // Очищаем таймер паузы при закрытии экрана
    _resetTimer?.cancel(); // Очищаем таймер сброса при закрытии экрана
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final txt = SpecialScreenTranslate(context.read<ProviderUserControl>().userModel.language_code ?? 'en');

    return Scaffold(
      appBar: AppBar(
        title: Text(txt.tt('title')),
      ),
      body: GestureDetector(
        onLongPress: () => _handleLongPress(context),
        onTap: () => _handleShortPress(context),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.transparent, // Контейнер делает нажатия активными по всей области
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                SizedBox(height: 35),
                Text(
                  txt.tt('tap_or_hold'),
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  txt.tt('wait_5_seconds'),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.italic,
                    color: Colors.black38,
                  ),
                ),
                SizedBox(height: 25),
                Text(
                  _inputSequence,
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                SizedBox(height: 100),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
