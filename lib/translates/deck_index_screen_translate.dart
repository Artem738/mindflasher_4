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


    // txt.tt('description')  ${txt.tt('description')}
    'description': {
      'en': 'Press the button below. Choose a deck from the list, tap on it to view and add it using the button below, or just press add to use a ready-made deck.',
      'ru': 'Нажмите кнопку снизу. Выберите колоду из списка, нажмите на неё, чтобы посмотреть и добавить кнопкой снизу, или просто нажмите добавить, чтобы использовать готовую колоду.',
      'uk': 'Натисніть кнопку знизу. Оберіть колоду зі списку, натисніть на неї, щоб переглянути та додати кнопкою знизу, або просто натисніть додати, щоб використати готову колоду.',
    },


  };




  final String languageCode;

  DeckIndexScreenTranslate(this.languageCode);

  String tt(String key) {
    return translations[key]?[languageCode] ?? translations[key]?['en'] ?? 'Default $key';
  }
}
