import 'package:flutter/material.dart';
import 'package:tintly/features/auth/services/auth_service.dart';
import 'package:tintly/features/user/models/user.dart';

class AuthController extends ChangeNotifier {
  final AuthService authService;
  List<User> auth = [];
  bool isLoading = false;

  AuthController(this.authService);

  Future<void> loadBrands() async {
    if (isLoading) return;

    isLoading = true;
    notifyListeners();

    try {
      final result = await authService.getAll();
      if (result.isFailure) {
        throw Exception(result.error);
      }
      auth = result.data!;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> create(User i) async {
    await authService.create(i);
    await loadBrands();
  }

  Future<void> update(User i) async {
    await authService.update(i);
    await loadBrands();
  }

  Future<void> delete(User i) async {
    await authService.delete(i.id);
    await loadBrands();
  }
}
