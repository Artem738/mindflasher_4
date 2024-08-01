import 'package:telegram_web_app/telegram_web_app.dart';
import 'package:mindflasher_4/models/user_model.dart';


class TelegramService {
  static Future<bool> isSupported() async {
    try {
      return TelegramWebApp.instance.isSupported;
    } catch (e) {
      print("Error checking Telegram support: $e");
      return false;
    }
  }

  static Future<UserModel> login() async {
    try {
      await TelegramWebApp.instance.ready();
      final telegramUser = TelegramWebApp.instance.initData?.user;
      if (telegramUser == null) {
        throw Exception('No Telegram user data available');
      }
      return UserModel(
        id: telegramUser.id.toString(),
        firstName: telegramUser.firstname,
        lastName: telegramUser.lastname,
        username: telegramUser.username,
      );
    } catch (e) {
      print("Error during Telegram login: $e");
      throw e;
    }
  }
}

