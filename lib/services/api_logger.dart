import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mindflasher_4/env_config.dart';


/// ApiLogger.apiPrint('Some error: $e');
/// СПЕЦИАЛЬНЫЙ КЛАСС ДЛЯ ПРОСТОГО ЛОГИРОВАНИЯ НА СЕРВЕРЕ, ПОЛЕЗНО...
class ApiLogger {
  static Future<void> apiPrint(String message) async {
    final url = Uri.parse("${EnvConfig.mainApiUrl}/api/log");
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'message': message,
      }),
    );

    if (response.statusCode != 200) {
      print('ApiLogger - Failed to send message');
      throw Exception('Failed to send message');
    } else {
      print("ApiLogger - $message");
    }

  }
}
