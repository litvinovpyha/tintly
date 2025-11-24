import 'package:hive/hive.dart';
import '../../../core/models/base_model.dart';

part 'client.g.dart';

@HiveType(typeId: 0)
class Client extends BaseModel {
  @HiveField(0)
  @override
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? photo;

  @HiveField(3)
  String? phone;

  @HiveField(4)
  String? birthday;

  @HiveField(5)
  String? comment;

  @HiveField(6)
  String? coloringTechnique;

  @HiveField(7)
  String? haircutType;

  @HiveField(8)
  String? serviceDuration;
  @HiveField(9)
  String? whatsapp;

  @HiveField(10)
  String? instagram;

  @HiveField(11)
  String? telegram;
  Client({
    required this.id,
    required this.name,
    this.photo,
    this.phone,
    this.birthday,
    this.comment,
    this.coloringTechnique,
    this.haircutType,
    this.serviceDuration,
    this.whatsapp,
    this.instagram,
    this.telegram,
  });
  Client copyWith({
    String? id,
    String? name,
    String? photo,
    String? phone,
    String? birthday,
    String? comment,
    String? coloringTechnique,
    String? haircutType,
    String? serviceDuration,
    String? whatsapp,
    String? instagram,
    String? telegram,
  }) {
    return Client(
      id: id ?? this.id,
      name: name ?? this.name,
      photo: photo ?? this.photo,
      phone: phone ?? this.phone,
      birthday: birthday ?? this.birthday,
      comment: comment ?? this.comment,
      coloringTechnique: coloringTechnique ?? this.coloringTechnique,
      haircutType: haircutType ?? this.haircutType,
      serviceDuration: serviceDuration ?? this.serviceDuration,
      whatsapp: whatsapp ?? this.whatsapp,
      instagram: instagram ?? this.instagram,
      telegram: telegram ?? this.telegram,
    );
  }

  @override
  List<String> get validationErrors {
    final errors = <String>[];
    if (id.isEmpty) errors.add('ID is required');
    if (name.isEmpty) errors.add('Name is required');
    return errors;
  }
}
