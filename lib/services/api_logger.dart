import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mindflasher_4/env_config.dart';
import 'package:mindflasher_4/services/logging/app_logger.dart';


/// ApiLogger.apiPrint('Some error: $e');
/// СПЕЦИАЛЬНЫЙ КЛАСС ДЛЯ ПРОСТОГО ЛОГИРОВАНИЯ НА СЕРВЕРЕ, ПОЛЕЗНО...
class ApiLogger {
  static Future<void> apiPrint(String message) async {
    final url = Uri.parse("${EnvConfig.mainApiUrl}/api/log");
    try {
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
        AppLogger.instance.warning('remote-log', 'Remote log endpoint returned ${response.statusCode}');
        debugPrint('ApiLogger => Failed to send message');
      } else {
        debugPrint("ApiLogger => $message");
      }
    } catch (e) {
      AppLogger.instance.warning('remote-log', 'Remote logging skipped: $e');
      debugPrint('ApiLogger => logging skipped: $e');
    }
  }
}
