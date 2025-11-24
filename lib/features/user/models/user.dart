import '../../../core/models/base_model.dart';
import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 4)
class User extends BaseModel {
  @HiveField(0)
  @override
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String email;
  @HiveField(3)
  final String phone;
  @HiveField(4)
  final String password;
  @HiveField(5)
  final String role;
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.role,
  });

  @override
  List<String> get validationErrors {
    final errors = <String>[];
    if (id.isEmpty) errors.add('ID is required');
    if (name.isEmpty) errors.add('Name is required');
    if (email.isEmpty) errors.add('Email is required');
    if (phone.isEmpty) errors.add('Phone is required');
    if (password.isEmpty) errors.add('Password is required');
    return errors;
  }
}
