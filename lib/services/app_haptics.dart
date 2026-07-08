import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:telegram_web_app/telegram_web_app.dart' as tg;

class AppHaptics {
  static void lightImpact() {
    if (kIsWeb) {
      try {
        if (tg.TelegramWebApp.instance.isSupported) {
          // impactOccurred на многих Android работает как микро-щелчок, который не чувствуется.
          // notificationOccurred('success') дает отчетливую двойную вибрацию.
          tg.TelegramWebApp.instance.hapticFeedback.notificationOccurred(
            tg.HapticFeedbackNotificationType.success
          );
          return;
        }
      } catch (e) {
        // Игнорируем ошибку
      }
    }
    
    HapticFeedback.lightImpact();
  }
}
