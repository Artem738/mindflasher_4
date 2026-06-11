import 'package:flutter/material.dart';
import 'package:mindflasher_4/providers/provider_user_control.dart';
import 'package:mindflasher_4/providers/provider_user_login.dart';
import 'package:provider/provider.dart';
import 'package:mindflasher_4/models/user_model.dart';

import '../main.dart';

enum Language {
  english('en', 'English', '🇬🇧'),
  ukrainian('uk', 'Українська', '🇺🇦'),
  russian('ru', 'Русский', '🇭🇳');

  final String code;
  final String name;
  final String flag;

  const Language(this.code, this.name, this.flag);

  static Language fromCode(String? code) {
    return Language.values.firstWhere(
      (lang) => lang.code == code,
      orElse: () => Language.english, // Default language
    );
  }
}

class LanguageSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Language'),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: Language.values.map((language) {
            return ListTile(
              leading: Container(
                margin: EdgeInsets.only(left: 30),
                width: 60, // Установленная ширина для флага
                alignment: Alignment.center, // Центрирование флага по горизонтали и вертикали
                child: Text(
                  language.flag,
                  style: TextStyle(fontSize: 22), // Уменьшение размера флага
                ),
              ),
              title: Text(
                language.name,
                style: TextStyle(fontSize: 30), // Увеличение размера текста
              ),
              onTap: () {
                _setLanguage(context, language);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _setLanguage(BuildContext context, Language language) async {
    final userModel = Provider.of<UserModel>(context, listen: false);
    final userControl = Provider.of<ProviderUserControl>(context, listen: false);
    final userLogin = Provider.of<ProviderUserLogin>(context, listen: false);

    await userLogin.saveLanguageCode(language.code);
    if (userModel.token != null) {
      await userControl.updateUserLanguageCode(language.code);
    }

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => IndexScreen()),
      (Route<dynamic> route) => false,
    );
  }
}
