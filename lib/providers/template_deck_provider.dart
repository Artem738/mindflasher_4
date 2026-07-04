import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mindflasher_4/env_config.dart';
import 'package:mindflasher_4/models/template_category_model.dart';
import 'package:mindflasher_4/models/user_model.dart';
import 'package:mindflasher_4/services/app_http_client.dart';

class TemplateDeckProvider extends ChangeNotifier {
  TemplateDeckProvider(UserModel userModel, {AppHttpClient? httpClient})
      : _userModel = userModel,
        _httpClient = httpClient ?? AppHttpClient();

  UserModel _userModel;
  final AppHttpClient _httpClient;
  final List<TemplateCategoryModel> _categories = [];

  List<TemplateCategoryModel> get categories => _categories;

  void updateUserModel(UserModel userModel) {
    _userModel = userModel;
  }

  String _token() => _userModel.requireToken();

  Map<String, String> _headers() {
    return _httpClient.jsonHeaders(
      bearerToken: _token(),
      extraHeaders: const {'Accept': 'application/json'},
    );
  }

  Future<void> fetchDecks() async {
    final apiUrl = '${EnvConfig.mainApiUrl}/api/template-decks';
    final response = await _httpClient.get(
      Uri.parse(apiUrl),
      headers: _headers(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      _categories.clear();

      _categories.addAll(data.map((item) => TemplateCategoryModel.fromJson(item)));
      notifyListeners();
    } else {
      throw AppHttpException('Failed to load template decks', statusCode: response.statusCode);
    }
  }
}
