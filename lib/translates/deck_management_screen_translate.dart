// deck_management_screen_translate.dart
class DeckManagementScreenTranslate {
  static const Map<String, Map<String, String>> translations = {
    // txt.tt('edit_deck_title')  ${txt.tt('edit_deck_title')}
    'edit_deck_title': {
      'en': 'Edit',
      'ru': 'Редактировать',
      'uk': 'Редагувати',
    },
    // txt.tt('create_deck_title')  ${txt.tt('create_deck_title')}
    'create_deck_title': {
      'en': 'Create Deck',
      'ru': 'Создать колоду',
      'uk': 'Створити колоду',
    },
    // txt.tt('deck_name_label')  ${txt.tt('deck_name_label')}
    'deck_name_label': {
      'en': 'Deck Name',
      'ru': 'Название колоды',
      'uk': 'Назва колоди',
    },
    // txt.tt('description_label')  ${txt.tt('description_label')}
    'description_label': {
      'en': 'Description',
      'ru': 'Описание',
      'uk': 'Опис',
    },
    // txt.tt('update_button')  ${txt.tt('update_button')}
    'update_button': {
      'en': 'Update',
      'ru': 'Обновить',
      'uk': 'Оновити',
    },
    // txt.tt('create_button')  ${txt.tt('create_button')}
    'create_button': {
      'en': 'Create',
      'ru': 'Создать',
      'uk': 'Створити',
    },
    // txt.tt('failed_to_update_deck')  ${txt.tt('failed_to_update_deck')}
    'failed_to_update_deck': {
      'en': 'Failed to update deck',
      'ru': 'Не удалось обновить колоду',
      'uk': 'Не вдалося оновити колоду',
    },
    // txt.tt('failed_to_create_deck')  ${txt.tt('failed_to_create_deck')}
    'failed_to_create_deck': {
      'en': 'Failed to create deck',
      'ru': 'Не удалось создать колоду',
      'uk': 'Не вдалося створити колоду',
    },
  };

  final String languageCode;

  DeckManagementScreenTranslate(this.languageCode);

  String tt(String key) {
    return translations[key]?[languageCode] ?? translations[key]?['en'] ?? '$key def';
  }
}
