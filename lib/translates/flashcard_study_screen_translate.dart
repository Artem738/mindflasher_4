class FlashcardStudyScreenTranslate {
  static const Map<String, Map<String, String>> translations = {
    'study_title': {
      'en': 'Study Flashcard',
      'ru': 'Изучение карточки',
      'uk': 'Вивчення картки',
    },
    'question': {
      'en': 'Question',
      'ru': 'Вопрос',
      'uk': 'Питання',
    },
    'answer': {
      'en': 'Answer',
      'ru': 'Ответ',
      'uk': 'Відповідь',
    },
    'show_answer': {
      'en': 'Show Answer',
      'ru': 'Показать ответ',
      'uk': 'Показати відповідь',
    },
    'grade_bad': {
      'en': 'Bad',
      'ru': 'Плохо',
      'uk': 'Погано',
    },
    'grade_medium': {
      'en': 'Medium',
      'ru': 'Средне',
      'uk': 'Середньо',
    },
    'grade_good': {
      'en': 'Know',
      'ru': 'Знаю',
      'uk': 'Знаю',
    },
    'view_full_answer': {
      'en': 'View full answer',
      'ru': 'Посмотреть полный ответ',
      'uk': 'Переглянути повну відповідь',
    },
  };

  final String languageCode;

  FlashcardStudyScreenTranslate(this.languageCode);

  String tt(String key) {
    return translations[key]?[languageCode] ?? translations[key]?['en'] ?? 'Default $key';
  }
}
