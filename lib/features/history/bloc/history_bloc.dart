import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tintly/features/history/bloc/history_event.dart';
import 'package:tintly/features/history/bloc/history_state.dart';
import 'package:tintly/features/history/models/consumption.dart';
import 'package:tintly/features/history/repository/history_repository.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final HistoryRepository r;
  List<Consumption> _allHistorys = [];

  HistoryBloc(this.r) : super(HistoryInitial()) {
    on<LoadHistory>((event, emit) async {
      emit(HistoryLoading());
      try {
        _allHistorys = await r.getAll();
        emit(HistoryLoaded(_allHistorys));
      } catch (e) {
        emit(HistoryError(e.toString()));
      }
    });

    on<AddHistory>((event, emit) async {
      try {
        final newHistory = await r.create(event.history);
        _allHistorys.add(newHistory);
        emit(HistoryLoaded(_allHistorys));
      } catch (e) {
        emit(HistoryError(e.toString()));
      }
    });

    on<UpdateHistory>((event, emit) async {
      try {
        final updated = await r.update(event.history);
        if (updated != null) {
          final index = _allHistorys.indexWhere((c) => c.id == updated.id);
          if (index != -1) _allHistorys[index] = updated;
          emit(HistoryLoaded(_allHistorys));
        }
      } catch (e) {
        emit(HistoryError(e.toString()));
      }
    });

    on<DeleteHistory>((event, emit) async {
      try {
        await r.delete(event.id);

        final updatedList = _allHistorys
            .where((c) => c.id != event.id)
            .toList();

        _allHistorys = updatedList;

        emit(HistoryLoaded(_allHistorys));
      } catch (e) {
        emit(HistoryError(e.toString()));
      }
    });
  }
}
