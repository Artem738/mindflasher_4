class LanguageSelectionScreenTranslate {
  static const Map<String, Map<String, String>> translations = {
    'title': {
      'en': 'Select Language',
      'ru': 'Выберите язык',
      'uk': 'Оберіть мову',
    },
  };

  final String languageCode;

  LanguageSelectionScreenTranslate(this.languageCode);

  String tt(String key) {
    return translations[key]?[languageCode] ?? translations[key]?['en'] ?? '$key default';
  }
}
