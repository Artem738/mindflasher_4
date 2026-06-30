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
    'study_mode_srs': {
      'en': 'Study (SRS)',
      'ru': 'Учеба (SRS)',
      'uk': 'Навчання (SRS)',
    },
    'study_mode_all': {
      'en': 'All Cards',
      'ru': 'Все карточки',
      'uk': 'Всі картки',
    },
    'srs_done_title': {
      'en': 'All caught up!',
      'ru': 'На сегодня всё повторено!',
      'uk': 'На сьогодні все повторено!',
    },
    'srs_done_subtitle': {
      'en': 'Great job! Come back tomorrow or switch to "All Cards" tab to review early.',
      'ru': 'Отличная работа! Возвращайтесь завтра или перейдите во вкладку "Все карточки" для внеочередного повторения.',
      'uk': 'Чудова робота! Повертайтеся завтра або перейдіть у вкладку "Всі картки" для позачергового повторення.',
    },
  };

  final String languageCode;

  FlashcardIndexScreenTranslate(this.languageCode);

  String tt(String key) {
    return translations[key]?[languageCode] ?? translations[key]?['en'] ?? 'Default $key';
  }
}
