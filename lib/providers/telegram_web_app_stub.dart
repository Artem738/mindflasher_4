class TelegramUser {
  final int id = 42;
  final String user = 'dummy_user';
  final String username = 'dummy_username';
  final String firstname = 'dummy_firstname';
  final String lastname = 'dummy_lastname';
  final String languageCode = 'en';

  TelegramUser();
}

class InitData {
  final TelegramUser user = TelegramUser(); // Поле user теперь типа TelegramUser
  final int authDate = 1;
  final String hash = 'dummy_hash';
  final String raw = 'dummy_raw';

  InitData();
}

class TelegramWebApp {
  static final TelegramWebApp instance = TelegramWebApp._();

  TelegramWebApp._();

  bool get isSupported => false;
  String get version => 'Not supported';
  dynamic get themeParams => null;
  InitData? get initData => InitData();

  Future<void> ready() async {}
  void expand() {}

  // Заглушка для мобильных платформ
  TelegramUser? get telegramUser => initData?.user;
}
