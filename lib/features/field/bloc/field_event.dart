import 'package:tintly/features/field/models/field.dart';

abstract class FieldEvent {}

class LoadFields extends FieldEvent {}

class AddField extends FieldEvent {
  final Field field;
  AddField(this.field);
}

class CreateField extends FieldEvent {
  final String name;
  final String placeholder;
  final String unitId;
  final bool isActive;
  final bool isChecked;
  CreateField(
    this.name,
    this.placeholder,
    this.unitId,
    this.isActive,
    this.isChecked,
  );
}

class UpdateFieldByName extends FieldEvent {
  final String id;
  final String newName;
  UpdateFieldByName(this.id, this.newName);
}

class UpdateFieldByPlasholder extends FieldEvent {
  final String id;
  final String newPlasholder;
  UpdateFieldByPlasholder(this.id, this.newPlasholder);
}

class UpdateField extends FieldEvent {
  final Field field;
  UpdateField(this.field);
}

class DeleteField extends FieldEvent {
  final String id;
  DeleteField(this.id);
}
