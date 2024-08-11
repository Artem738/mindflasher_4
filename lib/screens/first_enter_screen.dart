import 'package:flutter/material.dart';
import 'package:mindflasher_4/main.dart';
import 'package:mindflasher_4/models/user_model.dart';
import 'package:mindflasher_4/providers/provider_user_login.dart';
import 'package:mindflasher_4/translates/first_enterScreen_translate.dart';
import 'package:provider/provider.dart';

class FirstEnterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var txt = FirstEnterScreenTranslate(context.read<UserModel>().language_code ?? 'en');

    return Scaffold(
      appBar: AppBar(
        title: Text(txt.tt('title')),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              txt.tt('welcome'),
              style: TextStyle(fontSize: 26),
            ),
            SizedBox(height: 20), // Добавляем отступ между текстом и кнопкой
            ElevatedButton(
              onPressed: () {

                context.read<ProviderUserLogin>().setIsFirstEnter(false);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => IndexScreen()),
                  //MaterialPageRoute(builder: (context) => TemplateDeckIndexScreen()),
                );
              },
              child: Text(txt.tt('start'), style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}
