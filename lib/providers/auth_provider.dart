import 'package:flutter/material.dart';
import 'package:mindflasher_4/models/user_model.dart';
import 'package:mindflasher_4/services/auth_service.dart';
import 'package:mindflasher_4/services/telegram_service.dart';



class AuthProvider with ChangeNotifier {
  UserModel? _user;
  bool _isTelegramSupported = false;

  AuthProvider() {
    _checkTelegramSupport();
  }

  UserModel? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isTelegramSupported => _isTelegramSupported;

  Future<void> _checkTelegramSupport() async {
    _isTelegramSupported = await TelegramService.isSupported();
    notifyListeners();
  }

  Future<void> loginWithTelegram() async {
    try {
      _user = await TelegramService.login();
      notifyListeners();
    } catch (e) {
      print("Telegram login failed: $e");
    }
  }

  Future<void> loginWithEmail(String email, String password) async {
    try {
      _user = await AuthService.loginWithEmail(email, password);
      notifyListeners();
    } catch (e) {
      print("Email login failed: $e");
    }
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}
