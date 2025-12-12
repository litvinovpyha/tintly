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

  Brand copyWith({
    String? id,
    String? name,
    String? imageUrl,
    bool? isActive,
    String? placeholder,
  }) {
    return Brand(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      isActive: isActive ?? this.isActive,
      placeholder: placeholder ?? this.placeholder,
    );
  }


}
