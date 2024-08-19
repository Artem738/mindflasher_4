class LoginScreenTranslate {

  static const Map<String, Map<String, String>> translations = {
    'title': {
      'en': 'Login',
      'ru': 'Вход',
      'uk': 'Вхід',
    },
    'login_failed': {
      'en': 'Login failed',
      'ru': 'Ошибка входа',
      'uk': 'Помилка входу',
    },
    'register': {
      'en': "Don't have an account? Register!",
      'ru': 'Нет аккаунта? Зарегистрируйтесь!',
      'uk': 'Немає акаунта? Зареєструйтесь!',
    },
    'login': {
      'en': "Login",
      'ru': 'Войти',
      'uk': 'Увійти',
    },
    'password': {
      'en': "Password",
      'ru': 'Пароль',
      'uk': 'Пароль',
    },
  };


  final String languageCode;

  LoginScreenTranslate(this.languageCode);

  String tt(String key) {
    return translations[key]?[languageCode] ?? translations[key]?['en'] ?? '$key default';
  }
}
