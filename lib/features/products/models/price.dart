import '../../../core/models/base_model.dart';
import 'brand.dart';
import '../../admin/models/field.dart';
import 'package:hive/hive.dart';

part 'price.g.dart';

@HiveType(typeId: 6)
class Price extends BaseModel {
  @HiveField(0)
  @override
  final String id;
  @HiveField(1)
  final Brand brand;
  @HiveField(2)
  final Field field;
  @HiveField(3)
  final double pricePerUnit;
  @HiveField(4)
  final String? placeholder;

  Price({
    required this.id,
    required this.brand,
    required this.field,
    required this.pricePerUnit,
    required this.placeholder,
  });

  @override
  List<String> get validationErrors {
    final errors = <String>[];
    if (id.isEmpty) errors.add('ID is required');
    if (pricePerUnit < 0) errors.add('Price must be non-negative');
    return errors;
  }
}
