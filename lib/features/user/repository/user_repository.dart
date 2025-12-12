import 'package:tintly/core/repository/base_repository.dart';
import 'package:tintly/features/user/models/user.dart';
import 'package:tintly/shared/utils/id_generator.dart';

class UserRepository extends GenericRepository<User> {
  UserRepository() : super('user');

  @override
  Future<User> create(User item) async {
    final newUser = item.copyWith(
      id: IdGenerator.generate(),
      name: item.name,
      email: item.email,
      phone: item.phone,
      password: item.password,
      role: item.role,
    );

    await box.put(newUser.id, newUser);
    return newUser;
  }

  
}
