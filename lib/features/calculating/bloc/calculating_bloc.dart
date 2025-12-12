import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tintly/features/calculating/bloc/calculating_event.dart';
import 'package:tintly/features/calculating/bloc/calculating_state.dart';

class CalculatingBloc extends Bloc<CalculatingEvent, CalculatingState> {
  CalculatingBloc() : super(CalculatingInitial()) {
    on<UpdateTotal>((event, emit) {
      double currentTotal = 0.0;
      if (state is CalculatingLoaded) {
        currentTotal = (state as CalculatingLoaded).total;
      }
      final newTotal = currentTotal + event.price;
      emit(CalculatingLoaded(total: newTotal));
    });
  }
}
