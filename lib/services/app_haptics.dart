import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import '../providers/devise_special_load/telegram_web_app_stub.dart'
    if (dart.library.html) '../providers/devise_special_load/telegram_web_app_web.dart' as tg;

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
