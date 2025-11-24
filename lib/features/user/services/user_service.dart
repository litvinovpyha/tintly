import 'package:tintly/features/user/models/user.dart';
import 'package:tintly/core/services/base_service.dart';
import 'package:tintly/core/result.dart';

class UserService extends BaseService<User> {
  UserService(super.repository);

  @override
  Future<Result<User>> create(User item) async {
    final user = User(
      id: generateId(),
      name: item.name,
      email: item.email,
      phone: item.phone,
      password: item.password,
      role: item.role,
    );
    return super.create(user);
  }
}
