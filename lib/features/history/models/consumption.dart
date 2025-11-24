import 'package:hive/hive.dart';
import 'package:tintly/core/models/base_model.dart';

part 'consumption.g.dart';

@HiveType(typeId: 10) 
class Consumption extends BaseModel {
  @HiveField(0)
  @override
  final String id;
  @HiveField(1)
  final String productName;

  @HiveField(2)
  final double quantity;

  @HiveField(3)
  final String unit;

  Consumption({
    required this.id,
    required this.productName,
    required this.quantity,
    required this.unit,
  });

  @override
  List<String> get validationErrors {
    final errors = <String>[];
    if (id.isEmpty) errors.add('ID is required');
    if (productName.isEmpty) errors.add('Product name is required');
    if (quantity <= 0) errors.add('Quantity must be positive');
    if (unit.isEmpty) errors.add('Unit is required');
    return errors;
  }
}
