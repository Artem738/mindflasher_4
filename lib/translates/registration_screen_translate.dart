class RegistrationScreenTranslate {
  static const Map<String, Map<String, String>> translations = {
    'title': {
      'en': 'Register',
      'ru': 'Регистрация',
      'uk': 'Реєстрація',
    },
    'name': {
      'en': 'Name',
      'ru': 'Имя',
      'uk': "Ім'я",
    },
    'email': {
      'en': 'Email',
      'ru': 'Email',
      'uk': 'Email',
    },
    'password': {
      'en': 'Password',
      'ru': 'Пароль',
      'uk': 'Пароль',
    },
    'confirm_password': {
      'en': 'Confirm Password',
      'ru': 'Подтвердите пароль',
      'uk': 'Підтвердьте пароль',
    },
    'registration_failed': {
      'en': 'Registration failed',
      'ru': 'Ошибка регистрации',
      'uk': 'Помилка реєстрації',
    },
    'register_button': {
      'en': 'Register',
      'ru': 'Зарегистрироваться',
      'uk': 'Зареєструватися',
    },
  };

  final String languageCode;

  RegistrationScreenTranslate(this.languageCode);

  String tt(String key) {
    return translations[key]?[languageCode] ?? translations[key]?['en'] ?? '$key default';
  }
}
