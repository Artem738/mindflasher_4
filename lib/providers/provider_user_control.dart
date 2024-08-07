import 'package:flutter/material.dart';
import '../models/user_model.dart';

class ProviderUserControl with ChangeNotifier {
  UserModel _userModel;

  ProviderUserControl(this._userModel);

  UserModel get userModel => _userModel;

  void updateUserModel(UserModel userModel) {
    _userModel = userModel;
    notifyListeners();
  }

  void incrementApiId() {
    _userModel.incrementApiId();
    notifyListeners();
  }
}
