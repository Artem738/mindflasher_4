class FirstEnterScreenTranslate {
// var txt = FirstEnterScreenTranslate(context.read<UserModel>().language_code ?? 'en');
  static const Map<String, Map<String, String>> translations = {
    'title': {
      'en': 'Welcome',
      'ru': 'Добро пожаловать!',
      'uk': 'Ласкаво просимо!',
    },
    'welcome': {
      'en': 'Welcome',
      'ru': 'Добро пожаловать!',
      'uk': 'Ласкаво просимо!',
    },
    'start': {
      'en': 'Start',
      'ru': 'Начать',
      'uk': 'Почати',
    },

  };

  final String languageCode;

  FirstEnterScreenTranslate(this.languageCode);

  String tt(String key) {
    return translations[key]?[languageCode] ?? translations[key]?['en'] ?? 'Default $key';
  }
}
