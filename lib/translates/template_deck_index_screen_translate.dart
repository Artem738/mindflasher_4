// template_deck_index_screen_translate.dart
class TemplateDeckIndexScreenTranslate {
  static const Map<String, Map<String, String>> translations = {
    // txt.tt('template_decks')  ${txt.tt('template_decks')}
    'template_decks': {
      'en': 'Template Decks',
      'ru': 'Шаблонные Колоды',
      'uk': 'Шаблонні Колоди',
    },
    // txt.tt('error_occurred')  ${txt.tt('error_occurred')}
    'error_occurred': {
      'en': 'An error occurred',
      'ru': 'Произошла ошибка',
      'uk': 'Сталася помилка',
    },
    // txt.tt('failed_to_add')  ${txt.tt('failed_to_add')}
    'failed_to_add': {
      'en': 'Failed to add template base',
      'ru': 'Не удалось добавить шаблонную базу',
      'uk': 'Не вдалося додати шаблонну базу',
    },

    // txt.tt('add_own_deck')  ${txt.tt('add_own_deck')}
    'add_own_deck': {
      'en': 'Add Own Deck',
      'ru': 'Добавить собственную колоду',
      'uk': 'Додати власну колоду',
    },

    // txt.tt('add_button')  ${txt.tt('add_button')}
    'add_button': {
      'en': 'Add',
      'ru': 'Добавить',
      'uk': 'Додати',
    },

    'categories': {
      'en': 'Categories',
      'ru': 'Категории',
      'uk': 'Категорії',
    },

    'subcategories': {
      'en': 'Subcategories',
      'ru': 'Подкатегории',
      'uk': 'Підкатегорії',
    },

    'decks_count': {
      'en': 'Decks',
      'ru': 'Колоды',
      'uk': 'Колоди',
    },

    'search_hint': {
      'en': 'Search decks...',
      'ru': 'Поиск колод...',
      'uk': 'Пошук колод...',
    },

    'my_language_only': {
      'en': 'My language',
      'ru': 'Мой язык',
      'uk': 'Моя мова',
    },

    'all_languages': {
      'en': 'All languages',
      'ru': 'Все языки',
      'uk': 'Всі мови',
    },

    'no_results': {
      'en': 'No decks found',
      'ru': 'Колоды не найдены',
      'uk': 'Колод не знайдено',
    },

    'no_templates': {
      'en': 'No template decks available for your language',
      'ru': 'Нет доступных шаблонных колод для вашего языка',
      'uk': 'Немає доступних шаблонних колод для вашої мови',
    },

    'cards_count': {
      'en': 'cards',
      'ru': 'карточек',
      'uk': 'карток',
    },
  };

  final String languageCode;

  TemplateDeckIndexScreenTranslate(this.languageCode);

  String tt(String key) {
    return translations[key]?[languageCode] ?? translations[key]?['en'] ?? '$key default';
  }
}
