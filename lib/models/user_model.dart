class UserModel {
  final int? apiId;
  final int? tgId;  // Telegram ID
  final String? username;
  final String? firstname;
  final String? lastname;
  final String? languageCode;
  final String? email;
  final String? token;


  UserModel({
    this.apiId,
    this.tgId,
    required this.username,
    this.firstname,
    this.lastname,
    this.languageCode,
    this.email,
    this.token,
  });
}
