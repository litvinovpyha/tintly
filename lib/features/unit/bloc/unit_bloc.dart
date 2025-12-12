import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tintly/features/unit/bloc/unit_event.dart';
import 'package:tintly/features/unit/bloc/unit_state.dart';
import 'package:tintly/features/unit/models/unit.dart';
import 'package:tintly/features/unit/repository/unit_repository.dart';

class UnitBloc extends Bloc<UnitEvent, UnitState> {
  final UnitRepository r;
  List<Unit> _allUnits = [];

  UnitBloc(this.r) : super(UnitInitial()) {
    on<LoadUnits>((event, emit) async {
      emit(UnitLoading());
      try {
        _allUnits = await r.getAll();
        emit(UnitLoaded(_allUnits));
      } catch (e) {
        emit(UnitError(e.toString()));
      }
    });

    on<AddUnit>((event, emit) async {
      try {
        final newUnit = await r.create(event.unit);
        _allUnits.add(newUnit);
        emit(UnitLoaded(_allUnits));
      } catch (e) {
        emit(UnitError(e.toString()));
      }
    });

    on<UpdateUnit>((event, emit) async {
      try {
        final updated = await r.update(event.unit);
        if (updated != null) {
          final index = _allUnits.indexWhere((c) => c.id == updated.id);
          if (index != -1) _allUnits[index] = updated;
          emit(UnitLoaded(_allUnits));
        }
      } catch (e) {
        emit(UnitError(e.toString()));
      }
    });
    on<UpdateUnitByName>((event, emit) async {
      try {
        final oldUnit = _allUnits.firstWhere((u) => u.id == event.id);

        final updatedUnit = oldUnit.copyWith(name: event.newName);

        final savedUnit = await r.update(updatedUnit);

        if (savedUnit != null) {
          final index = _allUnits.indexWhere((c) => c.id == savedUnit.id);

          if (index != -1) {
            final updatedList = List<Unit>.from(_allUnits);
            updatedList[index] = savedUnit;
            _allUnits = updatedList; 
          }
          emit(UnitLoaded(_allUnits)); 
        }
      } catch (e) {
        emit(UnitError(e.toString()));
      }
    });

    on<DeleteUnit>((event, emit) async {
      try {
        await r.delete(event.id);

        final updatedList = _allUnits.where((c) => c.id != event.id).toList();

        _allUnits = updatedList;

        emit(UnitLoaded(_allUnits));
      } catch (e) {
        emit(UnitError(e.toString()));
      }
    });

    on<CreateUnitByName>((event, emit) async {
      try {
        final newUnit = await r.createByName(event.name);
        final updatedList = List<Unit>.from(_allUnits)..add(newUnit);

        _allUnits = updatedList;

        emit(UnitLoaded(_allUnits));
      } catch (e) {
        emit(UnitError(e.toString()));
      }
    });
  }
}
