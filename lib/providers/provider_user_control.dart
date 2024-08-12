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

  void increaseFontSize() {
    if (_userModel.base_font_size < 35) {
      _userModel.base_font_size += 1;
      notifyListeners();
    }
  }

  void decreaseFontSize() {
    if (_userModel.base_font_size > 5) {
      _userModel.base_font_size -= 1;
      notifyListeners();
    }
  }

  Future<void> updateUserBaseFontSize(String token, double baseFontSize) async {
    if (token == null) {
      throw Exception('User not authenticated');
    }

    final url = Uri.parse('${EnvConfig.mainApiUrl}/api/user/base-font-size');
    final response = await http.put(
      url, // Используем метод PUT, как указано в API маршрутах
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'base_font_size': baseFontSize}),
    );

    // Обновляем локальную модель пользователя
    _userModel.update(base_font_size: baseFontSize);
    notifyListeners();

    if (response.statusCode != 200) {
      throw Exception('Failed to update base font size on server');
    }
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

    if (response.statusCode != 200) {
      throw Exception('Failed to update language code on server');
    }
  }
}
