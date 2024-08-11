import 'package:flutter/material.dart';

class UserModel extends ChangeNotifier {
  int? apiId;
  int? telegram_id;
  String? tg_username;
  String? firstname;
  String? tg_last_name;
  String? languageCode;
  String? email;
  String? token;
  int? authDate;
  String? hash;
  int? user_lvl;
  bool? firstEnter;

  UserModel({
    this.apiId,
    this.telegram_id,
    this.tg_username,
    this.firstname,
    this.tg_last_name,
    this.languageCode,
    this.email,
    this.token,
    this.authDate,
    this.hash,
    this.user_lvl,
    this.firstEnter,
  });

  void update({
    int? apiId,
    int? telegram_id,
    String? tg_username,
    String? firstname,
    String? tg_last_name,
    String? languageCode,
    String? email,
    String? token,
    int? authDate,
    String? hash,
    int? user_lvl,
    bool? firstEnter,
  }) {
    this.apiId = apiId ?? this.apiId;
    this.telegram_id = telegram_id ?? this.telegram_id;
    this.tg_username = tg_username ?? this.tg_username;
    this.firstname = firstname ?? this.firstname;
    this.tg_last_name = tg_last_name ?? this.tg_last_name;
    this.languageCode = languageCode ?? this.languageCode;
    this.email = email ?? this.email;
    this.token = token ?? this.token;
    this.authDate = authDate ?? this.authDate;
    this.hash = hash ?? this.hash;
    this.user_lvl = user_lvl ?? this.user_lvl;
    this.firstEnter = firstEnter ?? this.firstEnter;
    notifyListeners();
  }

  void incrementApiId() {
    apiId = (apiId ?? 0) + 1;
    notifyListeners();
  }

  String log() {
    return 'UserModel - apiId: ${apiId ?? 'null'}, telegram_id: ${telegram_id ?? 'null'}, tg_username: ${tg_username ?? 'null'}, firstname: ${firstname ?? 'null'}, tg_last_name: ${tg_last_name ?? 'null'}, languageCode: ${languageCode ?? 'null'}, email: ${email ?? 'null'}, token: ${token ?? 'null'}, authDate: ${authDate ?? 'null'}, hash: ${hash ?? 'null'}, user_lvl: ${user_lvl ?? 'null'}, firstEnter: ${firstEnter ?? 'null'}';
  }

}
