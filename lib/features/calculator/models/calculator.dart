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
  Calculator copyWith({
    String? id,
    String? userId,
    String? name,
    String? placeholder,
    bool? isActive,
  }) {
    return Calculator(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      placeholder: placeholder ?? this.placeholder,
      isActive: isActive ?? this.isActive,
    );
  }

}
