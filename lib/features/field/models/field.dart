import '../../../core/models/base_model.dart';
import 'package:hive/hive.dart';

part 'field.g.dart';

@HiveType(typeId: 5)
class Field extends BaseModel {
  @HiveField(0)
  @override
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String? placeholder;
  @HiveField(3)
  final String unitId;
  @HiveField(4)
  final bool isActive;
  @HiveField(5)
  bool isChecked = false;

  Field({
    required this.id,
    required this.name,
    required this.placeholder,
    required this.unitId,
    required this.isActive,
    this.isChecked = false,
  });
  Field copyWith({
    String? name,
    String? placeholder,
    String? unitId,
    bool? isActive,
    bool? isChecked,
  }) {
    return Field(
      id: id,
      name: name ?? this.name,
      placeholder: placeholder ?? this.placeholder,
      unitId: unitId ?? this.unitId,
      isActive: isActive ?? this.isActive,
      isChecked: isChecked ?? this.isChecked,
    );
  }

}
