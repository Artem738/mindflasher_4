// font_size_adjustment_screen.dart
class FontSizeAdjustmentScreenTranslate {
  static const Map<String, Map<String, String>> translations = {
// txt.tt('title')  ${txt.tt('title')}
    'title': {
      'en': 'Choose Font Size',
      'ru': 'Выберите размер шрифта',
      'uk': 'Оберіть розмір шрифту',
    },
    // txt.tt('header')
    'header': {
      'en': 'Adjust Font Size',
      'ru': 'Изменить размер шрифта',
      'uk': 'Змінити розмір шрифту',
    },

    // txt.tt('font_example')
    'font_example': {
      'en': 'Font Example',
      'ru': 'Пример шрифта',
      'uk': 'Приклад шрифту',
    },

    // txt.tt('current_font_size')  ${txt.tt('current_font_size')}
    'current_font_size': {
      'en': 'Current Font Size',
      'ru': 'Текущий размер шрифта',
      'uk': 'Поточний розмір шрифту',
    },

  // txt.tt('finish_button')  ${txt.tt('finish_button')}
    'finish_button': {
      'en': 'Save',
      'ru': 'Сохранить',
      'uk': 'Зберегти',
    },

  // txt.tt('continue_button')  ${txt.tt('continue_button')}
    'continue_button': {
      'en': 'Continue',
      'ru': 'Продолжить',
      'uk': 'Продовжити',
    },
    'small': {
      'en': 'Small',
      'ru': 'Мелкий',
      'uk': 'Дрібний',
    },
    'medium': {
      'en': 'Medium',
      'ru': 'Средний',
      'uk': 'Середній',
    },
    'large': {
      'en': 'Large',
      'ru': 'Крупный',
      'uk': 'Великий',
    },
    'cancel_button': {
      'en': 'Cancel',
      'ru': 'Отменить',
      'uk': 'Скасувати',
    },

    // ARRAY

    // txt.tt('question_star')
    'question_star': {
      'en': '⭐️ Question',
      'ru': '⭐️ Вопрос',
      'uk': '⭐️ Питання',
    },

// txt.tt('short_answer_example')
    'short_answer_example': {
      'en': 'Example of a short answer.',
      'ru': 'Пример короткого ответа.',
      'uk': 'Приклад короткої відповіді.',
    },

// txt.tt('medium_question')
    'medium_question': {
      'en': '🔥 Medium size question.',
      'ru': '🔥 Средний размер вопроса.',
      'uk': '🔥 Середній розмір питання.',
    },

// txt.tt('hidden_answer')
    'hidden_answer': {
      'en': 'But with a real deck, the answer will be hidden under the question.',
      'ru': 'Но с реальной колодой, ответ будет скрыт под вопросом.',
      'uk': 'Але з реальною колодою відповідь буде прихована під питанням.',
    },

// txt.tt('font_size_prompt')
    'font_size_prompt': {
      'en': '💧 Choose a comfortable font size to easily read the text.',
      'ru': '💧 Выберите удобный размер шрифта, чтоб хорошо видеть текст.',
      'uk': '💧 Оберіть зручний розмір шрифту, щоб добре бачити текст.',
    },

// txt.tt('swipe_to_reveal_answer')
    'swipe_to_reveal_answer': {
      'en': 'With the real database, you can swipe the question card to the left to reveal the answer under the top card 👈',
      'ru': 'С реально базой, вы сможете отодвинуть карточку с вопросом влево и увидеть под верхней карточкой ответ 👈',
      'uk': 'З реальною базою, ви зможете відсунути картку з питанням вліво і побачити відповідь під верхньою карткою 👈',
    },
  };

  final String languageCode;

  FontSizeAdjustmentScreenTranslate(this.languageCode);

  String tt(String key) {
    return translations[key]?[languageCode] ?? translations[key]?['en'] ?? '$key default';
  }
}
