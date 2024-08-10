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
    notifyListeners();
  }

  void incrementApiId() {
    apiId = (apiId ?? 0) + 1;
    notifyListeners();
  }

  String log() {
    return 'UserModel - apiId: $apiId, telegram_id: $telegram_id, tg_username: $tg_username, firstname: $firstname, tg_last_name: $tg_last_name, languageCode: $languageCode, email: $email, token: $token, authDate: $authDate, hash: $hash, user_lvl: $user_lvl';
  }
}
