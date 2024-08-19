// flashcard_management_screen_translate.dart
class FlashcardManagementScreenTranslate {
  static const Map<String, Map<String, String>> translations = {
    // txt.tt('edit_flashcard_title')  ${txt.tt('edit_flashcard_title')}
    'edit_flashcard_title': {
      'en': 'Edit Flashcard',
      'ru': 'Редактировать карточку',
      'uk': 'Редагувати картку',
    },
    // txt.tt('create_flashcard_title')  ${txt.tt('create_flashcard_title')}
    'create_flashcard_title': {
      'en': 'Create Flashcard',
      'ru': 'Создать карточку',
      'uk': 'Створити картку',
    },
    // txt.tt('question_label')  ${txt.tt('question_label')}
    'question_label': {
      'en': 'Question',
      'ru': 'Вопрос',
      'uk': 'Питання',
    },
    // txt.tt('answer_label')  ${txt.tt('answer_label')}
    'answer_label': {
      'en': 'Answer',
      'ru': 'Ответ',
      'uk': 'Відповідь',
    },
    // txt.tt('update_button')  ${txt.tt('update_button')}
    'update_button': {
      'en': 'Update',
      'ru': 'Обновить',
      'uk': 'Оновити',
    },
    // txt.tt('add_button')  ${txt.tt('add_button')}
    'add_button': {
      'en': 'Add',
      'ru': 'Добавить',
      'uk': 'Додати',
    },
    // txt.tt('delete_button')  ${txt.tt('delete_button')}
    'delete_button': {
      'en': 'Delete',
      'ru': 'Удалить',
      'uk': 'Видалити',
    },
    // txt.tt('failed_to_update_flashcard')  ${txt.tt('failed_to_update_flashcard')}
    'failed_to_update_flashcard': {
      'en': 'Failed to update flashcard',
      'ru': 'Не удалось обновить карточку',
      'uk': 'Не вдалося оновити картку',
    },
    // txt.tt('failed_to_create_flashcard')  ${txt.tt('failed_to_create_flashcard')}
    'failed_to_create_flashcard': {
      'en': 'Failed to create flashcard',
      'ru': 'Не удалось создать карточку',
      'uk': 'Не вдалося створити картку',
    },
    // txt.tt('failed_to_delete_flashcard')  ${txt.tt('failed_to_delete_flashcard')}
    'failed_to_delete_flashcard': {
      'en': 'Failed to delete flashcard',
      'ru': 'Не удалось удалить карточку',
      'uk': 'Не вдалося видалити картку',
    },
  };

  final String languageCode;

  FlashcardManagementScreenTranslate(this.languageCode);

  String tt(String key) {
    return translations[key]?[languageCode] ?? translations[key]?['en'] ?? 'Default $key';
  }
}
