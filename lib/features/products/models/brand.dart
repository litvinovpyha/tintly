import '../../../core/models/base_model.dart';
import 'package:hive/hive.dart';

part 'brand.g.dart';

@HiveType(typeId: 8)
class Brand extends BaseModel {
  @HiveField(0)
  @override
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String? imageUrl;
  @HiveField(3)
  final bool isActive;
  @HiveField(4)
  final String? placeholder;

  Brand({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.isActive,
    required this.placeholder,
  });

  @override
  List<String> get validationErrors {
    final errors = <String>[];
    if (id.isEmpty) errors.add('ID is required');
    if (name.isEmpty) errors.add('Name is required');
    return errors;
  }
}
