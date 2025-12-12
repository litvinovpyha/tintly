import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tintly/features/calculatorSession/bloc/calculator_session_bloc.dart';
import 'package:tintly/features/calculatorSession/bloc/calculator_session_event.dart';
import 'package:tintly/features/calculatorSession/repository/calculator_session_repository.dart';
import 'package:tintly/features/calculatorSession/views/calculator_session_view.dart';

class CalculatorSessionScreen extends StatelessWidget {
  const CalculatorSessionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String? calculatorSessionId =
        ModalRoute.of(context)?.settings.arguments is String
        ? ModalRoute.of(context)!.settings.arguments as String
        : null;

    if (calculatorSessionId == null) {
      return const Scaffold(
        body: Center(child: Text('Ошибка: Сессия не предоставлена.')),
      );
    }
    return BlocProvider(
      create: (context) =>
          CalculatorSessionBloc(CalculatorSessionRepository())
            ..add(LoadCalculatorSessionItem(calculatorSessionId)),
      child: CalculatorSessionView(),
    );
  }
}
