// user_settings_screen_translate.dart
class UserSettingsScreenTranslate {
  static const Map<String, Map<String, String>> translations = {
    // txt.tt('user_settings_title')  ${txt.tt('user_settings_title')}
    'user_settings_title': {
      'en': 'User Settings',
      'ru': 'Настройки пользователя',
      'uk': 'Налаштування користувача',
    },
    // txt.tt('welcome')  ${txt.tt('welcome')}
    'welcome': {
      'en': 'Welcome',
      'ru': 'Добро пожаловать',
      'uk': 'Ласкаво просимо',
    },
    // txt.tt('api_id')  ${txt.tt('api_id')}
    'api_id': {
      'en': 'apiId',
      'ru': 'apiId',
      'uk': 'apiId',
    },
    // txt.tt('telegram_id')  ${txt.tt('telegram_id')}
    'telegram_id': {
      'en': 'Telegram ID',
      'ru': 'Telegram ID',
      'uk': 'Telegram ID',
    },
    // txt.tt('name')  ${txt.tt('name')}
    'name': {
      'en': 'Name',
      'ru': 'Имя',
      'uk': 'Ім\'я',
    },
    // txt.tt('username')  ${txt.tt('username')}
    'username': {
      'en': 'Username',
      'ru': 'Имя пользователя',
      'uk': 'Ім\'я користувача',
    },
    // txt.tt('email')  ${txt.tt('email')}
    'email': {
      'en': 'Email',
      'ru': 'Эл. почта',
      'uk': 'Ел. пошта',
    },
    // txt.tt('last_name')  ${txt.tt('last_name')}
    'last_name': {
      'en': 'Last Name',
      'ru': 'Фамилия',
      'uk': 'Прізвище',
    },
    // txt.tt('telegram_language')  ${txt.tt('telegram_language')}
    'telegram_language': {
      'en': 'Telegram Language',
      'ru': 'Telegram Язык',
      'uk': 'Telegram Мова',
    },
    // txt.tt('language')  ${txt.tt('language')}
    'language': {
      'en': 'Language',
      'ru': 'Язык',
      'uk': 'Мова',
    },
    // txt.tt('user_level')  ${txt.tt('user_level')}
    'user_level': {
      'en': 'Level',
      'ru': 'Уровень',
      'uk': 'Рівень',
    },
    // txt.tt('font_size')  ${txt.tt('font_size')}
    'font_size': {
      'en': 'Font Size',
      'ru': 'Размер шрифта',
      'uk': 'Розмір шрифту',
    },
    // txt.tt('adjust_font_size_button')  ${txt.tt('adjust_font_size_button')}
    'adjust_font_size_button': {
      'en': 'Adjust Font Size',
      'ru': 'Изменить размер шрифта',
      'uk': 'Змінити розмір шрифту',
    },
    // txt.tt('change_lang_button')  ${txt.tt('change_lang_button')}
    'change_lang_button': {
      'en': 'Change Language',
      'ru': 'Сменить язык',
      'uk': 'Змінити мову',
    },
    // txt.tt('tap_code_screen_button')  ${txt.tt('tap_code_screen_button')}
    'tap_code_screen_button': {
      'en': 'Tap Code Screen',
      'ru': 'Экран Tap Code',
      'uk': 'Екран Tap Code',
    },



  };

  final String languageCode;

  UserSettingsScreenTranslate(this.languageCode);

  String tt(String key) {
    return translations[key]?[languageCode] ?? translations[key]?['en'] ?? 'Default $key';
  }
}
