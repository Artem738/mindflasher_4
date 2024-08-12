// font_size_adjustment_screen.dart
class FontSizeAdjustmentScreenTranslate {
  static const Map<String, Map<String, String>> translations = {
    // txt.tt('title')
    'title': {
      'en': 'Adjust Font Size',
      'ru': 'Изменить размер шрифта',
      'uk': 'Змінити розмір шрифту',
    },
    // txt.tt('header')
    'header': {
      'en': 'Adjust Font Size',
      'ru': 'Изменить размер шрифта',
      'uk': 'Змінити розмір шрифту',
    },
    // txt.tt('finish_button')
    'finish_button': {
      'en': 'Finish',
      'ru': 'Завершить',
      'uk': 'Завершити',
    },
  };

  final String languageCode;

  FontSizeAdjustmentScreenTranslate(this.languageCode);

  String tt(String key) {
    return translations[key]?[languageCode] ?? translations[key]?['en'] ?? 'Default $key';
  }
}
