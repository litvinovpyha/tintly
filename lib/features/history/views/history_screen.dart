import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tintly/features/calculatorSession/bloc/calculator_session_bloc.dart';
import 'package:tintly/features/calculatorSession/bloc/calculator_session_event.dart';
import 'package:tintly/features/calculatorSession/repository/calculator_session_repository.dart';
import 'package:tintly/features/history/views/history_list.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CalculatorSessionBloc(CalculatorSessionRepository())
            ..add(LoadCalculatorSessions()),
      child: Builder(builder: (context) => HistoryList()),
    );
  }
}
