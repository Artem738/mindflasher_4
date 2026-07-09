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

  void ready() {}
  void expand() {}
  void disableVerticalSwipes() {}

  // Заглушка для мобильных платформ
  TelegramUser? get telegramUser => initData?.user;

  // Методы для алертов
  void showAlert(String message, Function() callback) {}
  void showConfirm(String message, Function(bool) callback) {}
  void showScanQrPopup(String message, Function(String) callback) {}
  void readTextFromClipboard(Function(String) callback) {}

  // Заглушка для HapticFeedback
  final _HapticFeedback hapticFeedback = _HapticFeedback();
}

class _HapticFeedback {
  void notificationOccurred(String type) {}
}

class HapticFeedbackNotificationType {
  static const String success = 'success';
}
