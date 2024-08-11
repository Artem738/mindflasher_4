import 'package:flutter/material.dart';
import 'package:mindflasher_4/main.dart';
import 'package:mindflasher_4/providers/provider_user_login.dart';
import 'package:provider/provider.dart';

class FirstEnterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('title'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Добро пожаловать !!!',
              style: TextStyle(fontSize: 26),
            ),
            SizedBox(height: 20), // Добавляем отступ между текстом и кнопкой
            ElevatedButton(
              onPressed: () {

                context.read<ProviderUserLogin>().setFirstEnterSharedPreferences();
                // Здесь можно добавить логику для перехода на другой экран или другое действие
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => IndexScreen()),
                  //MaterialPageRoute(builder: (context) => TemplateDeckIndexScreen()),
                );
              },
              child: Text('Start', style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}
