import '../../../core/models/base_model.dart';
import 'package:hive/hive.dart';

part 'unit.g.dart';

@HiveType(typeId: 7)
class Unit extends BaseModel {
  @HiveField(0)
  @override
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final bool isActive;
  @HiveField(3)
  final String? placeholder;

  Unit({
    required this.id,
    required this.name,
    required this.isActive,
    required this.placeholder,
  });
  Unit copyWith({
    String? id,
    String? name,
    bool? isActive,
    String? placeholder,
  }) {
    return Unit(
      id: id ?? this.id,
      name: name ?? this.name,
      isActive: isActive ?? this.isActive,
      placeholder: placeholder ?? this.placeholder,
    );
  }

}
