import 'package:hive/hive.dart';
import 'package:tintly/core/models/base_model.dart';

part 'consumption.g.dart';

@HiveType(typeId: 10)
class Consumption extends BaseModel {
  @HiveField(0)
  @override
  final String id;
  @HiveField(1)
  final String name;

  @HiveField(2)
  final double quantity;

  @HiveField(3)
  final String unit;

  Consumption({
    required this.id,
    required this.name,
    required this.quantity,
    required this.unit,
  });



  Consumption copyWith({
    String? id,
    String? name,
    double? quantity,
    String? unit,
  }) {
    return Consumption(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
    );
  }
}
