import 'package:hive_flutter/hive_flutter.dart';
  import 'package:tintly/shared/utils/id_generator.dart';
import '../../../features/user/models/user.dart';

class AuthRepository {
  final Box<User> authBox;
  static const String currentUserKey = 'currentUser';

  AuthRepository(this.authBox);

  Future<User?> register(String name, email, password, phone, role) async {
    if (email.isNotEmpty && password.length >= 6) {
      final newUser = User(
        id: IdGenerator.generate(),
        name: name,
        email: email,
        phone: phone,
        password: password,
        role: role,
      );

      await authBox.put(currentUserKey, newUser);
      return newUser;
    }
    return null;
  }

  Future<User?> logIn(String email, password) async {
    // это проверка
    if (email == 'test@example.com' && password == 'password') {
      final loggedInUser = User(
        id: IdGenerator.generate(),
        name: 'admin',
        email: email,
        phone: '88005553535',
        password: password,
        role: 'admin',
      );
      await authBox.put(currentUserKey, loggedInUser);
      return loggedInUser;
    }
    return null;
  }

  Future<void> logOut() async {
    await authBox.delete(currentUserKey);
  }

  Future<User?> getCurrentUser() async {
    final loggedInUser = User(
      id: IdGenerator.generate(),
      name: 'admin',
      email: 'email',
      phone: '88005553535',
      password: 'password',
      role: 'admin',
    );
    return loggedInUser;
    // return authBox.get(currentUserKey);
  }

  Future<User> changeRole(String newRole) async {
    final user = await getCurrentUser();
    if (user != null) {
      final newUser = user.copyWith(role: newRole);

      await authBox.put(currentUserKey, newUser);
      return newUser;
    }
    throw Exception("User not found");
  }
}
