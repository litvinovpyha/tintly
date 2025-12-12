import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tintly/features/field/bloc/field_event.dart';
import 'package:tintly/features/field/bloc/field_state.dart';
import 'package:tintly/features/field/models/field.dart';
import 'package:tintly/features/field/repository/field_repository.dart';

class FieldBloc extends Bloc<FieldEvent, FieldState> {
  final FieldRepository r;

  List<Field> _allFields = [];

  FieldBloc(this.r) : super(FieldInitial()) {
    on<LoadFields>((event, emit) async {
      emit(FieldLoading());
      try {
        _allFields = await r.getAll();

        emit(FieldsLoaded(_allFields));
      } catch (e) {
        emit(FieldError(e.toString()));
      }
    });
    on<AddField>((event, emit) async {
      try {
        final newField = await r.create(event.field);
        _allFields = List<Field>.from(_allFields)..add(newField);
        emit(FieldsLoaded(_allFields));
      } catch (e) {
        emit(FieldError(e.toString()));
      }
    });
    on<CreateField>((event, emit) async {
      try {
        final field = Field(
          id: '',
          name: event.name,
          placeholder: event.placeholder,
          unitId: event.unitId,
          isActive: event.isActive,
          isChecked: event.isChecked,
        );
        final newField = await r.create(field);
        _allFields = List<Field>.from(_allFields)..add(newField);
        emit(FieldsLoaded(_allFields));
      } catch (e) {
        emit(FieldError(e.toString()));
      }
    });

    on<UpdateField>((event, emit) async {
      try {
        final updatedField = await r.update(event.field);
        if (updatedField != null) {
          final index = _allFields.indexWhere((c) => c.id == updatedField.id);
          if (index != -1) _allFields[index] = updatedField;
          emit(FieldsLoaded(_allFields));
        }
      } catch (e) {
        emit(FieldError(e.toString()));
      }
    });
    on<UpdateFieldByName>((event, emit) async {
      try {
        final oldField = _allFields.firstWhere((u) => u.id == event.id);

        final updatedField = oldField.copyWith(name: event.newName);

        final savedField = await r.update(updatedField);

        if (savedField != null) {
          final index = _allFields.indexWhere((c) => c.id == savedField.id);

          if (index != -1) {
            final updatedList = List<Field>.from(_allFields);
            updatedList[index] = savedField;
            _allFields = updatedList; 
          }
          emit(FieldsLoaded(_allFields)); 
        }
      } catch (e) {
        emit(FieldError(e.toString()));
      }
    });

    on<DeleteField>((event, emit) async {
      try {
        await r.delete(event.id);
        _allFields = _allFields.where((c) => c.id != event.id).toList();
        emit(FieldsLoaded(_allFields));
      } catch (e) {
        emit(FieldError(e.toString()));
      }
    });
  }
}
