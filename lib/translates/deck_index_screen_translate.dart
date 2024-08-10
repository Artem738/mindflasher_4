class DeckIndexScreenTranslate {
  static const Map<String, Map<String, String>> translations = {
    'title': {
      'en': 'Deck',
      'ru': 'Колоды',
      'uk': 'Колоди',
    },
    'no_decks': {
      'en': 'No decks available.',
      'ru': 'Нет доступных колод.',
      'uk': 'Немає доступних колод.',
    },
    'add_deck_prompt': {
      'en': 'Please add a new deck to get started.',
      'ru': 'Пожалуйста, добавьте новую колоду, чтобы начать.',
      'uk': 'Будь ласка, додайте нову колоду, щоб розпочати.',
    },
    'add_deck': {
      'en': 'Add Deck',
      'ru': 'Добавить колоду',
      'uk': 'Додати колоду',
    },
  };

  final String languageCode;

  DeckIndexScreenTranslate(this.languageCode);

  String tt(String key) {
    return translations[key]?[languageCode] ?? translations[key]?['en'] ?? 'Default $key';
  }
}
