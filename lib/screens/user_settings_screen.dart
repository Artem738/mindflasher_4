import 'package:flutter/material.dart';
import 'package:mindflasher_4/screens/deck/deck_index_screen.dart';
import 'package:mindflasher_4/screens/first_enter_screen.dart';
import 'package:mindflasher_4/screens/font_size_adjustment_screen.dart';
import 'package:mindflasher_4/screens/language_selection_screen.dart';
import 'package:mindflasher_4/screens/tap_code_screen.dart'; // Добавлен новый экран
import 'package:mindflasher_4/translates/font_size_adjustment_screen.dart';
import 'package:mindflasher_4/translates/user_settings_screen_translate.dart';
import 'package:provider/provider.dart';
import '../providers/provider_user_control.dart';

class UserSettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userControl = context.watch<ProviderUserControl>();
    final userModel = userControl.userModel;
    final baseFontSize = userModel.base_font_size;

    var txt = UserSettingsScreenTranslate(userModel.language_code ?? 'en');

    return Scaffold(
      appBar: AppBar(
        title: Text(txt.tt('user_settings_title')),
        leading: ModalRoute.of(context)?.canPop == true
            ? null // Если есть роут возврата, оставляем стандартный AppBar
            : IconButton(
                // Если роута возврата нет, добавляем свою кнопку
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => DeckIndexScreen(),
                    ),
                  );
                },
              ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ' ${txt.tt('welcome')} ${userModel.tg_first_name ?? userModel.name ?? ''}',
                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: (baseFontSize + 5).clamp(10.0 + 5, 22.0 + 5)),
                ),
                const SizedBox(height: 15),
                Text(
                  '${txt.tt('api_id')}: ${userModel.apiId ?? ''}',
                  style: TextStyle(fontSize: (baseFontSize).clamp(10.0, 22.0)),
                ),
                Text(
                  '${txt.tt('telegram_id')}: ${userModel.telegram_id ?? ''}',
                  style: TextStyle(fontSize: (baseFontSize).clamp(10.0, 22.0)),
                ),
                Text(
                  '${txt.tt('name')}: ${userModel.name ?? ''}',
                  style: TextStyle(fontSize: (baseFontSize).clamp(10.0, 22.0)),
                ),
                Text(
                  '${txt.tt('username')}: ${userModel.tg_username ?? ''}',
                  style: TextStyle(fontSize: (baseFontSize).clamp(10.0, 22.0)),
                ),
                Text(
                  '${txt.tt('email')}: ${userModel.email ?? ''}',
                  style: TextStyle(fontSize: (baseFontSize).clamp(10.0, 22.0)),
                ),
                Text(
                  '${txt.tt('last_name')}: ${userModel.tg_last_name ?? ''}',
                  style: TextStyle(fontSize: (baseFontSize).clamp(10.0, 22.0)),
                ),
                Text(
                  '${txt.tt('telegram_language')}: ${userModel.tg_language_code ?? ''}',
                  style: TextStyle(fontSize: (baseFontSize).clamp(10.0, 22.0)),
                ),
                Text(
                  '${txt.tt('language')}: ${userModel.language_code ?? ''}',
                  style: TextStyle(fontSize: (baseFontSize).clamp(10.0, 22.0)),
                ),
                Text(
                  '${txt.tt('user_level')}: ${userModel.user_lvl ?? ''}',
                  style: TextStyle(fontSize: (baseFontSize).clamp(10.0, 22.0)),
                ),
                Text(
                  '${txt.tt('font_size')}: ${userModel.base_font_size ?? ''}',
                  style: TextStyle(fontSize: (baseFontSize).clamp(10.0, 22.0)),
                ),
                Text(
                  '${txt.tt('isFirstEnter')}: ${userModel.isFirstEnter.toString()}',
                  style: TextStyle(fontSize: (baseFontSize).clamp(10.0, 22.0)),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FontSizeAdjustmentScreen(),
                      ),
                      (Route<dynamic> route) => false,
                    );
                  },
                  child: Text(
                    txt.tt('adjust_font_size_button'),
                    style: TextStyle(fontSize: (baseFontSize).clamp(10.0, 22.0)),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LanguageSelectionScreen()),
                    );
                  },
                  child: Text(
                    txt.tt('change_lang_button'),
                    style: TextStyle(fontSize: (baseFontSize).clamp(10.0, 22.0)),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => FirstEnterScreen()),
                    );
                  },
                  child: Text(
                    txt.tt('information'),
                    style: TextStyle(fontSize: (baseFontSize).clamp(10.0, 22.0)),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TapCodeScreen()),
                    );
                  },
                  child: Text(txt.tt('tap_code_screen_button'), style: TextStyle(fontSize: (baseFontSize).clamp(10.0, 22.0))),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DeckIndexScreen(),
                      ),
                          (Route<dynamic> route) => false,
                    );
                    // Navigator.pushReplacement(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => DeckIndexScreen()),
                    // );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen, // Задаем зелёный цвет фона кнопки
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16), // Добавляем отступы
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Скругляем углы кнопки
                    ),
                  ),
                  child: Center(
                    child: Text(
                      txt.tt('to_main'),
                      style: TextStyle(
                        fontSize: (baseFontSize + 3).clamp(12.0+3, 22.0+3),
                        color: Colors.black87
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
