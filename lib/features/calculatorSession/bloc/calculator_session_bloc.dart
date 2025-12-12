import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tintly/features/calculatorSession/bloc/calculator_session_event.dart';
import 'package:tintly/features/calculatorSession/bloc/calculator_session_state.dart';
import 'package:tintly/features/calculatorSession/models/calculator_session.dart';
import 'package:tintly/features/calculatorSession/repository/calculator_session_repository.dart';

class CalculatorSessionBloc
    extends Bloc<CalculatorSessionEvent, CalculatorSessionState> {
  final CalculatorSessionRepository r;

  List<CalculatorSession> _allCalculatorSessions = [];

  CalculatorSessionBloc(this.r) : super(CalculatorSessionInitial()) {
    on<LoadCalculatorSessions>((event, emit) async {
      emit(CalculatorSessionLoading());
      try {
        _allCalculatorSessions = await r.getAll();

        emit(CalculatorSessionLoaded(_allCalculatorSessions));
      } catch (e) {
        emit(CalculatorSessionError(e.toString()));
      }
    });
    on<LoadCalculatorSessionItem>((event, emit) async {
      emit(CalculatorSessionLoading());
      try {
        final calculator = await r.get(event.id);

        if (calculator != null) {
          emit(CalculatorSessionItemLoaded(calculator));
        }
      } catch (e) {
        emit(CalculatorSessionError(e.toString()));
      }
    });

    on<AddCalculatorSession>((event, emit) async {
      try {
        final newCalculatorSession = await r.create(
          CalculatorSession(
            id: '',
            userId: event.userId,
            clientId: event.clientId ?? '',
            calculatorId: event.calculatorId,
            createdAt: DateTime.now(),
            totalAmount: event.totalAmount,
            calculatorName: event.calculatorName,
          ),
        );
        _allCalculatorSessions = List<CalculatorSession>.from(
          _allCalculatorSessions,
        )..add(newCalculatorSession);
        emit(CalculatorSessionLoaded(_allCalculatorSessions));
      } catch (e) {
        emit(CalculatorSessionError(e.toString()));
      }
    });

    on<UpdateCalculatorSession>((event, emit) async {
      try {
        final updatedCalculatorSession = await r.update(
          event.calculatorSession,
        );
        if (updatedCalculatorSession != null) {
          final index = _allCalculatorSessions.indexWhere(
            (c) => c.id == updatedCalculatorSession.id,
          );
          if (index != -1) {
            _allCalculatorSessions[index] = updatedCalculatorSession;
          }
          emit(CalculatorSessionLoaded(_allCalculatorSessions));
        }
      } catch (e) {
        emit(CalculatorSessionError(e.toString()));
      }
    });

    on<DeleteCalculatorSession>((event, emit) async {
      try {
        await r.delete(event.id);
        _allCalculatorSessions = _allCalculatorSessions
            .where((c) => c.id != event.id)
            .toList();
        emit(CalculatorSessionLoaded(_allCalculatorSessions));
      } catch (e) {
        emit(CalculatorSessionError(e.toString()));
      }
    });
    on<ClearAllSessions>((event, emit) async {
      try {
        await r.clearAllSessions();

        emit(CalculatorSessionLoaded([]));
      } catch (e) {
        emit(CalculatorSessionError(e.toString()));
      }
    });
  }
}
