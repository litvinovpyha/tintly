import 'package:tintly/features/unit/models/unit.dart';

abstract class UnitEvent {}

class LoadUnits extends UnitEvent {}

class AddUnit extends UnitEvent {
  final Unit unit;
  AddUnit(this.unit);
}

class UpdateUnit extends UnitEvent {
  final Unit unit;
  UpdateUnit(this.unit);
}

class UpdateUnitByName extends UnitEvent {
  final String newName;
  final String id;
  UpdateUnitByName(this.id,this.newName);
}

class DeleteUnit extends UnitEvent {
  final String id;
  DeleteUnit(this.id);
}

class CreateUnitByName extends UnitEvent {
  final String name;
  CreateUnitByName(this.name);
}
