import 'package:flutter/material.dart';

class UserModel extends ChangeNotifier {
  int? apiId;
  int? telegram_id;
  String? name;
  String? tg_username;
  String? tg_first_name;
  String? tg_last_name;
  String? tg_language_code;
  String? language_code;
  String? email;
  String? token;
  int? authDate;
  String? hash;
  int? user_lvl;
  bool? isFirstEnter;

  UserModel({
    this.apiId,
    this.telegram_id,
    this.name,
    this.tg_username,
    this.tg_first_name,
    this.tg_last_name,
    this.tg_language_code,
    this.language_code,
    this.email,
    this.token,
    this.authDate,
    this.hash,
    this.user_lvl,
    this.isFirstEnter,
  });

  void update({
    int? apiId,
    int? telegram_id,
    String? name,
    String? tg_username,
    String? tg_first_name,
    String? tg_last_name,
    String? tg_language_code,
    String? language_code,
    String? email,
    String? token,
    int? authDate,
    String? hash,
    int? user_lvl,
    bool? isFirstEnter,
  }) {
    this.apiId = apiId ?? this.apiId;
    this.telegram_id = telegram_id ?? this.telegram_id;
    this.name = name ?? this.name;
    this.tg_username = tg_username ?? this.tg_username;
    this.tg_first_name = tg_first_name ?? this.tg_first_name;
    this.tg_last_name = tg_last_name ?? this.tg_last_name;
    this.tg_language_code = tg_language_code ?? this.tg_language_code;
    this.language_code = language_code ?? this.language_code;
    this.email = email ?? this.email;
    this.token = token ?? this.token;
    this.authDate = authDate ?? this.authDate;
    this.hash = hash ?? this.hash;
    this.user_lvl = user_lvl ?? this.user_lvl;
    this.isFirstEnter = isFirstEnter ?? this.isFirstEnter;
    notifyListeners();
  }

  void incrementApiId() {
    apiId = (apiId ?? 0) + 1;
    notifyListeners();
  }

  String log() {
    return 'UserModel - apiId: ${apiId ?? 'null'}, telegram_id: ${telegram_id ?? 'null'}, tg_username: ${tg_username ?? 'null'}, name: ${name ?? 'null'}, tg_first_name: ${tg_first_name ?? 'null'}, tg_last_name: ${tg_last_name ?? 'null'}, tg_language_code: ${tg_language_code ?? 'null'}, language_code: ${language_code ?? 'null'}, email: ${email ?? 'null'}, token: ${token ?? 'null'}, authDate: ${authDate ?? 'null'}, hash: ${hash ?? 'null'}, user_lvl: ${user_lvl ?? 'null'}, isFirstEnter: ${isFirstEnter ?? 'null'}';
  }
}
