class UserModel {
  final String id;
  final String? firstName;
  final String? lastName;
  final String? username;
  final String? email;

  UserModel({
    required this.id,
    this.firstName,
    this.lastName,
    this.username,
    this.email,
  });
}
