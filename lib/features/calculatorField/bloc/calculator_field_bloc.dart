import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tintly/features/calculatorField/bloc/calculator_field_event.dart';
import 'package:tintly/features/calculatorField/bloc/calculator_field_state.dart';
import 'package:tintly/features/calculatorField/models/calculator_field.dart';
import 'package:tintly/features/calculatorField/repository/calculator_field_repository.dart';

class CalculatorFieldBloc
    extends Bloc<CalculatorFieldEvent, CalculatorFieldState> {
  final CalculatorFieldRepository r;

  List<CalculatorField> _allCalculatorFields = [];

  CalculatorFieldBloc(this.r) : super(CalculatorFieldInitial()) {
    on<LoadCalculatorFields>((event, emit) async {
      emit(CalculatorFieldLoading());
      try {
        _allCalculatorFields = await r.getAll();

        emit(CalculatorFieldsLoaded(_allCalculatorFields));
      } catch (e) {
        emit(CalculatorFieldError(e.toString()));
      }
    });
    on<LoadCalculatorFieldsForSession>((event, emit) async {
      try {
        final fieldsForSession = await r.getFieldsByCalculatorId(
          event.calculatorId,
        );

        fieldsForSession.sort((a, b) => a.position.compareTo(b.position));

        _allCalculatorFields = fieldsForSession;

        emit(CalculatorFieldsLoaded(_allCalculatorFields));
      } catch (e) {
        emit(CalculatorFieldError(e.toString()));
      }
    });

    on<AddCalculatorField>((event, emit) async {
      try {
        final newCalculatorField = await r.create(event.calculatorField);
        _allCalculatorFields = List<CalculatorField>.from(_allCalculatorFields)
          ..add(newCalculatorField);
        emit(CalculatorFieldsLoaded(_allCalculatorFields));
      } catch (e) {
        emit(CalculatorFieldError(e.toString()));
      }
    });
    on<CreateCalculatorField>((event, emit) async {
      try {
        await r.createById(
          event.calculatorId,
          event.fieldId,
        );
        add(LoadCalculatorFieldsForSession(event.calculatorId));

        emit(CalculatorFieldsLoaded(_allCalculatorFields));
      } catch (e) {
        emit(CalculatorFieldError(e.toString()));
      }
    });

    on<UpdateCalculatorField>((event, emit) async {
      try {
        final updatedCalculatorField = await r.update(event.calculatorField);
        if (updatedCalculatorField != null) {
          final index = _allCalculatorFields.indexWhere(
            (c) => c.id == updatedCalculatorField.id,
          );
          if (index != -1) _allCalculatorFields[index] = updatedCalculatorField;
          emit(CalculatorFieldsLoaded(_allCalculatorFields));
        }
      } catch (e) {
        emit(CalculatorFieldError(e.toString()));
      }
    });

    on<ReorderCalculatorFields>((event, emit) async {
      if (state is! CalculatorFieldsLoaded) return;

      final current = List.of(
        (state as CalculatorFieldsLoaded).calculatorFields,
      );

      final item = current.removeAt(event.oldIndex);
      current.insert(event.newIndex, item);

      for (int i = 0; i < current.length; i++) {
        current[i] = current[i].copyWith(position: i);
      }

      await r.updatePositions(current);

      emit(CalculatorFieldsLoaded(current));
    });

    on<DeleteCalculatorField>((event, emit) async {
      try {
        await r.delete(event.id);
        _allCalculatorFields = _allCalculatorFields
            .where((c) => c.id != event.id)
            .toList();
        emit(CalculatorFieldsLoaded(_allCalculatorFields));
      } catch (e) {
        emit(CalculatorFieldError(e.toString()));
      }
    });
  }
}
