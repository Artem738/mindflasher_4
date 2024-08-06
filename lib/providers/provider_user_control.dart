import 'package:flutter/material.dart';
import '../models/user_model.dart';

class ProviderUserControl with ChangeNotifier {
  UserModel? _userModel;

  UserModel? get userModel => _userModel;

  void updateUser(UserModel user) {
    _userModel = user;
    notifyListeners();
  }

  void clearUser() {
    _userModel = null;
    notifyListeners();
  }

  void initializeUser(UserModel user) {
    _userModel = user;
    notifyListeners();
  }

  void incrementApiId() {
    if (_userModel != null) {
      _userModel = _userModel!.copyWith(apiId: (_userModel!.apiId ?? 0) + 1);
      notifyListeners();
    }
  }
}
