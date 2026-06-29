import '../../providers/devise_special_load/telegram_web_app_stub.dart'
    if (dart.library.html) '../../providers/devise_special_load/telegram_web_app_web.dart';

export '../../providers/devise_special_load/telegram_web_app_stub.dart'
    if (dart.library.html) '../../providers/devise_special_load/telegram_web_app_web.dart';

abstract class TelegramAuthBridge {
  bool get isSupported;

  TelegramUser? get user;

  String? get initDataRaw;

  Future<void> ready();

  void expand();

  void disableVerticalSwipes();
}

class TelegramWebAppBridge implements TelegramAuthBridge {
  @override
  bool get isSupported {
    try {
      return TelegramWebApp.instance.isSupported;
    } catch (_) {
      return false;
    }
  }

  @override
  String? get initDataRaw {
    try {
      return TelegramWebApp.instance.initData?.raw;
    } catch (_) {
      return null;
    }
  }

  @override
  TelegramUser? get user {
    try {
      return TelegramWebApp.instance.initData?.user;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> ready() async {
    try {
      TelegramWebApp.instance.ready();
    } catch (_) {
    }
  }

  @override
  void expand() {
    try {
      TelegramWebApp.instance.expand();
    } catch (_) {
    }
  }

  @override
  void disableVerticalSwipes() {
    try {
      TelegramWebApp.instance.disableVerticalSwipes();
    } catch (_) {
    }
  }
}