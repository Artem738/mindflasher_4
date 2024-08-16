import 'package:flutter/material.dart';
import 'package:mindflasher_4/main.dart';
import 'package:mindflasher_4/models/user_model.dart';
import 'package:mindflasher_4/providers/provider_user_login.dart';
import 'package:mindflasher_4/screens/user_settings_screen.dart';
import 'package:mindflasher_4/translates/first_enterScreen_translate.dart';
import 'package:provider/provider.dart';

class FirstEnterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var txt = FirstEnterScreenTranslate(context.read<UserModel>().language_code ?? 'en');
    final userModel = context.read<UserModel>();
    final baseFontSize = userModel.base_font_size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          txt.tt('title'),
          style: TextStyle(fontSize: (baseFontSize + 5).clamp(15.0 + 5, 20.0 + 5)),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Отступы от краев экрана
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (userModel.tg_first_name != false) ...[
                // Text(
                //   "Welcome ${userModel.tg_first_name}",
                //   style: TextStyle(fontSize: 26),
                // ),
              ] else ...[
                Text(
                  txt.tt('alternative_welcome'),
                  style: TextStyle(fontSize: (baseFontSize + 5).clamp(15.0 + 5, 20.0 + 5)),
                ),
                Text(
                  "First enter ${userModel.isFirstEnter.toString()}",
                  style: TextStyle(fontSize: (baseFontSize + 5).clamp(15.0 + 5, 20.0 + 5)),
                ),
                SizedBox(height: 20),
              ],
              Text(
                txt.tt('leitner_method'),
                style: TextStyle(fontSize: (baseFontSize).clamp(15.0, 20.0)),
              ),
              SizedBox(height: 10),
              Text(
                txt.tt('deck_instruction'),
                style: TextStyle(fontSize: (baseFontSize).clamp(15.0, 20.0)),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () => _showSnackBar(context, txt.tt('green_snackbar_message'), Colors.green, Icons.more_time_rounded),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // Задаем цвет фона кнопки
                      padding: EdgeInsets.all(12), // Добавляем отступы для создания круглой формы
                      shape: CircleBorder(), // Делаем кнопку круглой
                      minimumSize: Size(48, 48), // Минимальный размер кнопки для сохранения круглой формы
                    ),
                    child: Center(
                      child: Icon(Icons.more_time_rounded),
                    ),
                  ),
                  SizedBox(width: 8), // Добавляем немного пространства между кнопкой и текстом
                  Expanded(
                    child: Text(
                      txt.tt('green_icon_explanation'),
                      style: TextStyle(fontSize: (baseFontSize).clamp(15.0, 20.0)),
                      softWrap: true, // Включаем перенос текста
                      overflow: TextOverflow.clip, // Обрезка текста в пределах экрана
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                txt.tt('yellow_red_buttons'),
                style: TextStyle(fontSize: (baseFontSize).clamp(15.0, 20.0)),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () => _showSnackBar(context, txt.tt('yellow_snackbar_message'), Colors.yellow, Icons.access_time_outlined),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow, // Задаем цвет фона кнопки
                      padding: EdgeInsets.all(12), // Добавляем отступы для создания круглой формы
                      shape: CircleBorder(), // Делаем кнопку круглой
                      minimumSize: Size(48, 48), // Минимальный размер кнопки для сохранения круглой формы
                    ),
                    child: Center(
                      child: Icon(Icons.access_time_outlined),
                    ),
                  ),
                  SizedBox(width: 8), // Добавляем немного пространства между кнопкой и текстом
                  Expanded(
                    child: Text(
                      txt.tt('yellow_button_explanation'),
                      style: TextStyle(fontSize: (baseFontSize).clamp(15.0, 20.0)),
                      softWrap: true, // Включаем перенос текста
                      overflow: TextOverflow.clip, // Обрезка текста в пределах экрана
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                txt.tt('wait_explanation'),
                style: TextStyle(fontSize: (baseFontSize).clamp(15.0, 20.0)),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () => _showSnackBar(context, txt.tt('red_snackbar_message'), Colors.redAccent, Icons.timer_outlined),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent, // Задаем цвет фона кнопки
                      padding: EdgeInsets.all(12), // Добавляем отступы для создания круглой формы
                      shape: CircleBorder(), // Делаем кнопку круглой
                      minimumSize: Size(48, 48), // Минимальный размер кнопки для сохранения круглой формы
                    ),
                    child: Center(
                      child: Icon(Icons.timer_outlined),
                    ),
                  ),
                  SizedBox(width: 8), // Добавляем немного пространства между кнопкой и текстом
                  Expanded(
                    child: Text(
                      txt.tt('red_button_explanation'),
                      style: TextStyle(fontSize: (baseFontSize).clamp(15.0, 20.0)),
                      softWrap: true, // Включаем перенос текста
                      overflow: TextOverflow.clip, // Обрезка текста в пределах экрана
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                txt.tt('evaluation_reminder'),
                style: TextStyle(fontSize: (baseFontSize).clamp(15.0, 20.0)),
              ),
              SizedBox(height: 20),
              if (userModel.isFirstEnter == true) ...[
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<ProviderUserLogin>().setIsFirstEnter(false);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => IndexScreen()),
                      );
                    },
                    child: Text(
                      txt.tt('start'),
                      style: TextStyle(fontSize: (baseFontSize + 5).clamp(15.0 + 5, 20.0 + 5)),
                    ),
                  ),
                ),
              ] else ...[
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<ProviderUserLogin>().setIsFirstEnter(false);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => UserSettingsScreen()),
                      );
                    },
                    child: Text(
                      txt.tt('back'),
                      style: TextStyle(fontSize: (baseFontSize + 5).clamp(15.0 + 5, 20.0 + 5)),
                    ),
                  ),
                ),
                SizedBox(height: 30),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message, Color buttonColor, IconData buttonIcon) {
    final double baseFontSize = context.read<UserModel>().base_font_size;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                padding: EdgeInsets.all(12),
                shape: CircleBorder(),
                minimumSize: Size(24, 24),
              ),
              child: Icon(
                buttonIcon,
                size: 16,
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: TextStyle(fontSize: baseFontSize),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
