class UserModel {
  final int? apiId;
  final int? tgId;  // Telegram ID
  final String? username;
  final String? firstname;
  final String? lastname;
  final String? languageCode;
  final String? email;
  final String? token;
  final int? authDate;
  final String? hash;

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
  });

  Map<String, dynamic> toJson() {
    return {
      'tgId': tgId,
      'username': username,
      'firstname': firstname,
      'lastname': lastname,
      'languageCode': languageCode,
      'authDate': authDate,
      'hash': hash,
    };
  }

  UserModel copyWith({
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
  }) {
    return UserModel(
      apiId: apiId ?? this.apiId,
      tgId: tgId ?? this.tgId,
      username: username ?? this.username,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      languageCode: languageCode ?? this.languageCode,
      email: email ?? this.email,
      token: token ?? this.token,
      authDate: authDate ?? this.authDate,
      hash: hash ?? this.hash,
    );
  }
}