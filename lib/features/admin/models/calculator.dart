import 'package:hive/hive.dart';
import '../../../core/models/base_model.dart';

part 'calculator.g.dart';

@HiveType(typeId: 1)
class Calculator extends BaseModel {
  @HiveField(0)
  @override
  final String id;
  @HiveField(1)
  final String userId;
  @HiveField(2)
  final String name;
  @HiveField(3)
  final String placeholder;
  @HiveField(4)
  final bool isActive;

  Calculator({
    required this.id,
    required this.userId,
    required this.name,
    required this.placeholder,
    required this.isActive,
  });

  @override
  List<String> get validationErrors {
    final errors = <String>[];
    if (id.isEmpty) errors.add('ID is required');
    if (userId.isEmpty) errors.add('User ID is required');
    if (name.isEmpty) errors.add('Name is required');
    if (placeholder.isEmpty) errors.add('Placeholder is required');
    return errors;
  }
}
