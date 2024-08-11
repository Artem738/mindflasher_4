import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mindflasher_4/env_config.dart';
import 'package:http/http.dart' as http;
import 'package:mindflasher_4/models/user_model.dart';

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

  Future<void> updateUserLanguageCode(String token, String languageCode) async {
    if (token == null) {
      throw Exception('User not authenticated');
    }

    final url = Uri.parse('${EnvConfig.mainApiUrl}/api/user/language');
    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'language_code': languageCode}),
    );
    _userModel.update(language_code: languageCode);
    notifyListeners();
    print(response.statusCode);

    if (response.statusCode != 200) {
      throw Exception('Failed to update language code on server');
    }
  }
}
