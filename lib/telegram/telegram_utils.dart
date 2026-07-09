import 'package:flutter/material.dart';
import '../providers/devise_special_load/telegram_web_app_stub.dart'
    if (dart.library.html) '../providers/devise_special_load/telegram_web_app_web.dart';
import 'package:mindflasher_4/screens/util/snackbar_extension.dart';

class TelegramUtil {
  static final TelegramWebApp telegram = TelegramWebApp.instance;

  static Future<void> showAlert(BuildContext context, String message) async {
    try {
      telegram.showAlert(
        message,
            () => 'Alert closed'.showSnackbar(context),
      );
    } catch (ex) {
      'error happened showing alert: $ex'.showSnackbar(context);
    }
  }

  static Future<void> showConfirm(BuildContext context, String message) async {
    try {
      telegram.showConfirm(
        message,
            (okPressed) {
          if (okPressed) {
            'Confirm closed. Ok pressed'.showSnackbar(context);
          } else {
            'Confirm closed. Cancel pressed'.showSnackbar(context);
          }
        },
      );
    } catch (ex) {
      'error happened showing confirm: $ex'.showSnackbar(context);
    }
  }

  static Future<void> showScanQrPopup(BuildContext context, String message) async {
    try {
      telegram.showScanQrPopup(
        message,
            (result) {
          'Got QR: $result'.showSnackbar(context);
          return false; // Вернуть false, чтобы закрыть QR popup
        },
      );
    } catch (ex) {
      'error happened showing QR popup: $ex'.showSnackbar(context);
    }
  }

  static Future<void> readTextFromClipboard(BuildContext context) async {
    try {
      telegram.readTextFromClipboard(
            (result) {
          'Clipboard text: $result, You can call this method only by MainButton'.showSnackbar(context);
        },
      );
    } catch (ex) {
      'error happened reading clipboard: $ex'.showSnackbar(context);
    }
  }
}
