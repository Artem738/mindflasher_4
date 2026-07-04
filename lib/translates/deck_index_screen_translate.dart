class DeckIndexScreenTranslate {
  static const Map<String, Map<String, String>> translations = {
    'title': {
      'en': 'Deck',
      'ru': 'Колоды',
      'uk': 'Колоди',
    },
    'no_decks': {
      'en': 'Welcome to LeitnerCards, {name}! 👋',
      'ru': 'Рады видеть вас в LeitnerCards, {name}! 👋',
      'uk': 'Раді бачити вас у LeitnerCards, {name}! 👋',
    },
    'add_deck_prompt': {
      'en': 'It\'s empty here because you haven\'t added any decks yet. LeitnerCards helps you memorize any information (words, definitions, formulas) using the Leitner spaced repetition system.',
      'ru': 'Пока здесь пусто, так как вы еще не добавили ни одной колоды. LeitnerCards помогает запоминать любую информацию (слова, термины, формулы) с помощью интервальной системы Лейтнера.',
      'uk': 'Поки що тут порожньо, оскільки ви ще не додали жодної колоди. LeitnerCards допомагає запам\'ятовувати будь-яку інформацію (слова, терміни, формули) за допомогою інтервальної системи Лейтнера.',
    },

    'add_deck_title': {
      'en': 'Add Deck',
      'ru': 'Добавить колоду',
      'uk': 'Додати колоду',
    },
// txt.tt('add_own_deck')  ${txt.tt('add_own_deck')}
    'add_own_deck': {
      'en': 'Add Own Deck',
      'ru': 'Добавить собственную колоду',
      'uk': 'Додати власну колоду',
    },

// txt.tt('add_template_deck')  ${txt.tt('add_template_deck')}
    'add_template_deck': {
      'en': 'Add Template Deck',
      'ru': 'Добавить шаблонную колоду',
      'uk': 'Додати шаблонну колоду',
    },

    // txt.tt('description')  ${txt.tt('description')}
    'description': {
      'en': 'To get started, tap the \'+\' button at the bottom of the screen:\n\n• Choose a ready-made template (like English vocabulary) to start learning immediately.\n• Or create a fresh deck and add your own flashcards.',
      'ru': 'Чтобы начать, нажмите кнопку «+» внизу экрана:\n\n• Выберите готовый шаблон (например, английские слова), чтобы сразу начать обучение.\n• Или создайте чистую колоду и добавьте свои собственные карточки.',
      'uk': 'Щоб почати, натисніть кнопку «+» внизу екрана:\n\n• Оберіть готовий шаблон (наприклад, англійські слова), щоб одразу розпочати навчання.\n• Або створіть власну порожню колоду та додайте свої картки.',
    },
    'how_to_use': {
      'en': 'How to use?',
      'ru': 'Как пользоваться?',
      'uk': 'Як користуватись?',
    },
  };

  final String languageCode;

  DeckIndexScreenTranslate(this.languageCode);

  String tt(String key) {
    return translations[key]?[languageCode] ?? translations[key]?['en'] ?? '$key default';
  }
}
