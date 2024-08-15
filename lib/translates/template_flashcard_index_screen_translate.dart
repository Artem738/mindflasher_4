// template_flashcard_index_screen_translate.dart
class TemplateFlashcardIndexScreenTranslate {
  static const Map<String, Map<String, String>> translations = {
    // txt.tt('error_occurred')  ${txt.tt('error_occurred')}
    'error_occurred': {
      'en': 'An error occurred',
      'ru': 'Произошла ошибка',
      'uk': 'Сталася помилка',
    },
    // txt.tt('template_base_added')  ${txt.tt('template_base_added')}
    'template_base_added': {
      'en': 'Template base successfully added to your Decks',
      'ru': 'Шаблонная база успешно добавлена в ваши колоды',
      'uk': 'Шаблонну базу успішно додано до ваших колод',
    },
    // txt.tt('failed_to_add')  ${txt.tt('failed_to_add')}
    'failed_to_add': {
      'en': 'Failed to add template base',
      'ru': 'Не удалось добавить шаблонную базу',
      'uk': 'Не вдалося додати шаблонну базу',
    },
    // txt.tt('make_your_own')  ${txt.tt('make_your_own')}
    'make_your_own': {
      'en': 'Make it Your Own',
      'ru': 'Сделать собственной',
      'uk': 'Зробити власною',
    },
  };

  final String languageCode;

  TemplateFlashcardIndexScreenTranslate(this.languageCode);

  String tt(String key) {
    return translations[key]?[languageCode] ?? translations[key]?['en'] ?? 'Default $key';
  }
}
