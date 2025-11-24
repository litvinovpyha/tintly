import 'package:flutter/material.dart';
import 'package:tintly/features/user/models/user.dart';
import 'package:tintly/features/user/services/user_service.dart';

class UserController extends ChangeNotifier {
  final UserService userService;
  List<User> users = [];
  bool isLoading = false;

  UserController(this.userService);

  Future<void> loadUsers() async {
    if (isLoading) return;

    isLoading = true;
    notifyListeners();

    try {
      final result = await userService.getAll();
      if (result.isFailure) {
        throw Exception(result.error);
      }
      users = result.data!;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> create(User user) async {
    await userService.create(user);
    await loadUsers();
  }

  Future<void> delete(User i) async {
    await userService.delete(i.id);
    await loadUsers();
  }
}
