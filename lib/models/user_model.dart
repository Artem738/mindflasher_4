import 'package:flutter/material.dart';

class UserModel extends ChangeNotifier {
  int? apiId;
  int? tgId;
  String? username;
  String? firstname;
  String? lastname;
  String? languageCode;
  String? email;
  String? token;
  int? authDate;
  String? hash;
  int? user_lvl;

  UserModel({
    this.apiId,
    this.tgId,
    this.username,
    this.firstname,
    this.lastname,
    this.languageCode,
    this.email,
    this.token,
    this.authDate,
    this.hash,
    this.user_lvl,
  });

  void update({
    int? apiId,
    int? tgId,
    String? username,
    String? firstname,
    String? lastname,
    String? languageCode,
    String? email,
    String? token,
    int? authDate,
    String? hash,
    int? user_lvl,
  }) {
    this.apiId = apiId ?? this.apiId;
    this.tgId = tgId ?? this.tgId;
    this.username = username ?? this.username;
    this.firstname = firstname ?? this.firstname;
    this.lastname = lastname ?? this.lastname;
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
    return 'UserModel - apiId: $apiId, tgId: $tgId, username: $username, firstname: $firstname, lastname: $lastname, languageCode: $languageCode, email: $email, token: $token, authDate: $authDate, hash: $hash, user_lvl: $user_lvl';
  }
}
