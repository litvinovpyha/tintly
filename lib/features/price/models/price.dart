import '../../../core/models/base_model.dart';
import '../../brand/models/brand.dart';
import '../../field/models/field.dart';
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

  Price copyWith({
    String? id,
    Brand? brand,
    Field? field,
    double? pricePerUnit,
    String? placeholder,
  }) {
    return Price(
      id: id ?? this.id,
      brand: brand ?? this.brand,
      field: field ?? this.field,
      pricePerUnit: pricePerUnit ?? this.pricePerUnit,
      placeholder: placeholder ?? this.placeholder,
    );
  }
}
