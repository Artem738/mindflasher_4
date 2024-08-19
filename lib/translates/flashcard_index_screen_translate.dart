// flashcard_index_screen_translate.dart
class FlashcardIndexScreenTranslate {
  static const Map<String, Map<String, String>> translations = {
    // txt.tt('flashcard_index_title')  ${txt.tt('flashcard_index_title')}
    'flashcard_index_title': {
      'en': 'Flashcard Index',
      'ru': 'Индекс флеш-карточек',
      'uk': 'Індекс флеш-карток',
    },
    // txt.tt('error_occurred')  ${txt.tt('error_occurred')}
    'error_occurred': {
      'en': 'An error occurred',
      'ru': 'Произошла ошибка',
      'uk': 'Сталася помилка',
    },
    // txt.tt('add_flashcard')  ${txt.tt('add_flashcard')}
    'add_flashcard': {
      'en': 'Add Flashcard',
      'ru': 'Добавить флеш-карточку',
      'uk': 'Додати флеш-картку',
    },
  };

  final String languageCode;

  FlashcardIndexScreenTranslate(this.languageCode);

  String tt(String key) {
    return translations[key]?[languageCode] ?? translations[key]?['en'] ?? 'Default $key';
  }
}
