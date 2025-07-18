import 'package:hive/hive.dart';
import '../models/user.dart';

class AuthService {
  static final Box<User> usersBox = Hive.box<User>('usersBox');

  static Future<bool> registerUser(String username, String password) async {
    // Check if user already exists
    final existingUser = usersBox.values.firstWhere(
          (user) => user.username == username,
      orElse: () => User(username: '', password: ''),
    );

    if (existingUser.username.isNotEmpty) {
      return false; // Username already taken
    }

    final newUser = User(username: username, password: password);
    await usersBox.add(newUser);
    return true;
  }

  static bool loginUser(String username, String password) {
    final matchingUser = usersBox.values.firstWhere(
          (user) => user.username == username && user.password == password,
      orElse: () => User(username: '', password: ''),
    );

    return matchingUser.username.isNotEmpty;
  }
}
