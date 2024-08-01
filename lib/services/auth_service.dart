import 'package:mindflasher_4/models/user_model.dart';

class AuthService {
  static Future<UserModel> loginWithEmail(String email, String password) async {
    // TODO: Implement email login logic
    return UserModel(id: '1', email: email, firstName: 'Test', lastName: 'User');
  }
}
