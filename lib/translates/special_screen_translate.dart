// special_screen_translate.dart
class SpecialScreenTranslate {
  static const Map<String, Map<String, String>> translations = {
    // txt.tt('title')
    'title': {
      'en': 'Special Screen',
      'ru': 'Специальный экран',
      'uk': 'Спеціальний екран',
    },
    // txt.tt('tap_or_hold')
    'tap_or_hold': {
      'en': 'Tap or Hold',
      'ru': 'Нажмите или Удерживайте',
      'uk': 'Натисніть або Утримуйте',
    },
    // txt.tt('wait_5_seconds')
    'wait_5_seconds': {
      'en': 'Wait 5 seconds to restart',
      'ru': 'Подождите 5 секунд, чтобы перезапустить',
      'uk': 'Зачекайте 5 секунд, щоб перезапустити',
    },
  };

  final String languageCode;

  SpecialScreenTranslate(this.languageCode);

  String tt(String key) {
    return translations[key]?[languageCode] ?? translations[key]?['en'] ?? 'Default $key';
  }
}
