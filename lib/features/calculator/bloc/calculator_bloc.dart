import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tintly/features/calculator/bloc/calculator_event.dart';
import 'package:tintly/features/calculator/bloc/calculator_state.dart';
import 'package:tintly/features/calculator/repository/calculator_repository.dart';
import 'package:tintly/features/calculator/models/calculator.dart';

class CalculatorBloc extends Bloc<CalculatorEvent, CalculatorState> {
  final CalculatorRepository r;
  List<Calculator> _allCalculators = [];

  CalculatorBloc(this.r) : super(CalculatorInitial()) {
    on<LoadCalculators>((event, emit) async {
      emit(CalculatorLoading());
      try {
        _allCalculators = await r.getAll();
        emit(CalculatorsLoaded(_allCalculators));
      } catch (e) {
        emit(CalculatorError(e.toString()));
      }
    });
    on<LoadCalculatorById>((event, emit) async {
      emit(CalculatorLoading());
      try {
        final calculator = await r.get(event.id);

        if (calculator != null) {
          emit(CalculatorItemLoaded(calculator));
        } else {
          emit(CalculatorError('Калькулятор с ID ${event.id} не найден.'));
        }
      } catch (e) {
        emit(CalculatorError(e.toString()));
      }
    });

    on<AddCalculator>((event, emit) async {
      try {
        final newCalculator = await r.create(event.calculator);
        _allCalculators.add(newCalculator);
        emit(CalculatorsLoaded(_allCalculators));
      } catch (e) {
        emit(CalculatorError(e.toString()));
      }
    });

    on<UpdateCalculator>((event, emit) async {
      try {
        final updated = await r.update(event.calculator);
        if (updated != null) {
          final index = _allCalculators.indexWhere((c) => c.id == updated.id);
          if (index != -1) _allCalculators[index] = updated;
          emit(CalculatorsLoaded(_allCalculators));
        }
      } catch (e) {
        emit(CalculatorError(e.toString()));
      }
    });
    on<UpdateCalculatorByName>((event, emit) async {
      try {
        final oldCalculator = _allCalculators.firstWhere(
          (u) => u.id == event.id,
        );

        final updatedCalculator = oldCalculator.copyWith(name: event.newName);

        // 3. Вызываем репозиторий для сохранения
        final savedCalculator = await r.update(updatedCalculator);

        // 4. Обновляем и эмитируем список (с использованием иммутабельности)
        if (savedCalculator != null) {
          final index = _allCalculators.indexWhere(
            (c) => c.id == savedCalculator.id,
          );

          if (index != -1) {
            final updatedList = List<Calculator>.from(_allCalculators);
            updatedList[index] = savedCalculator;
            _allCalculators = updatedList; // Обновляем внутреннее поле
          }
          emit(CalculatorsLoaded(_allCalculators)); // Эмитируем новую ссылку
        }
      } catch (e) {
        emit(CalculatorError(e.toString()));
      }
    });

    on<DeleteCalculator>((event, emit) async {
      try {
        await r.delete(event.id);

        final updatedList = _allCalculators
            .where((c) => c.id != event.id)
            .toList();

        _allCalculators = updatedList;

        emit(CalculatorsLoaded(_allCalculators));
      } catch (e) {
        emit(CalculatorError(e.toString()));
      }
    });

    on<CreateCalculatorByName>((event, emit) async {
      try {
        final newCalculator = await r.createCalculatorByName(
          event.userId,
          event.name,
        );
        final updatedList = List<Calculator>.from(_allCalculators)
          ..add(newCalculator);

        _allCalculators = updatedList;

        emit(CalculatorsLoaded(_allCalculators));
      } catch (e) {
        emit(CalculatorError(e.toString()));
      }
    });
  }
}
