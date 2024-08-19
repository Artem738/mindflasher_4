// deck_settings_screen_translate.dart
class DeckSettingsScreenTranslate {
  static const Map<String, Map<String, String>> translations = {
    // txt.tt('deck_settings_title')  ${txt.tt('deck_settings_title')}
    'deck_settings_title': {
      'en': 'Deck Settings',
      'ru': 'Настройки колоды',
      'uk': 'Налаштування колоди',
    },
    // txt.tt('deck')  ${txt.tt('deck')}
    'deck': {
      'en': 'Deck',
      'ru': 'Колода',
      'uk': 'Колода',
    },
    // txt.tt('deck_id')  ${txt.tt('deck_id')}
    'deck_id': {
      'en': 'Deck ID',
      'ru': 'ID колоды',
      'uk': 'ID колоди',
    },
    // txt.tt('edit_deck')  ${txt.tt('edit_deck')}
    'edit_deck': {
      'en': 'Edit Deck',
      'ru': 'Редактировать колоду',
      'uk': 'Редагувати колоду',
    },
    // txt.tt('csv_insert')  ${txt.tt('csv_insert')}
    'csv_insert': {
      'en': 'Insert CSV',
      'ru': 'Вставить CSV',
      'uk': 'Вставити CSV',
    },
    // txt.tt('csv_get_data')  ${txt.tt('csv_get_data')}
    'csv_get_data': {
      'en': 'Get CSV Data',
      'ru': 'Получить данные CSV',
      'uk': 'Отримати дані CSV',
    },
    // txt.tt('to_main')  ${txt.tt('to_main')}
    'to_main': {
      'en': 'To Main',
      'ru': 'На главную',
      'uk': 'На головну',
    },
    // txt.tt('delete_confirmation')  ${txt.tt('delete_confirmation')}
    'delete_confirmation': {
      'en': 'Are you sure you want to delete this deck?',
      'ru': 'Вы уверены, что хотите удалить эту колоду?',
      'uk': 'Ви впевнені, що хочете видалити цю колоду?',
    },
    // txt.tt('delete_button')  ${txt.tt('delete_button')}
    'delete_button': {
      'en': 'Delete',
      'ru': 'Удалить',
      'uk': 'Видалити',
    },
    // txt.tt('cancel_button')  ${txt.tt('cancel_button')}
    'cancel_button': {
      'en': 'Cancel',
      'ru': 'Отмена',
      'uk': 'Скасувати',
    },
  };

  final String languageCode;

  DeckSettingsScreenTranslate(this.languageCode);

  String tt(String key) {
    return translations[key]?[languageCode] ?? translations[key]?['en'] ?? '$key default ';
  }
}
