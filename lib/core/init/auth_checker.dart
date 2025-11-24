import 'package:hive/hive.dart';

class AuthChecker {
  static Future<bool> isLoggedIn() async {
    final box = await Hive.openBox('authBox');
    return box.get('isLoggedIn', defaultValue: false);
  }
}
