import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tintly/features/calculating/bloc/calculating_bloc.dart';
import 'package:tintly/features/calculating/bloc/calculating_state.dart';
import 'package:tintly/features/calculating/views/calculating_fields_list.dart';
import 'package:tintly/features/calculating/views/save_button.dart';
import 'package:tintly/features/calculator/bloc/calculator_bloc.dart';
import 'package:tintly/features/calculator/bloc/calculator_event.dart';
import 'package:tintly/features/calculator/bloc/calculator_state.dart';
import 'package:tintly/features/calculator/repository/calculator_repository.dart';
import 'package:tintly/features/calculatorField/bloc/calculator_field_bloc.dart';
import 'package:tintly/features/calculatorField/bloc/calculator_field_event.dart';
import 'package:tintly/features/calculatorField/repository/calculator_field_repository.dart';
import 'package:tintly/features/calculatorSession/bloc/calculator_session_bloc.dart';
import 'package:tintly/features/calculatorSession/repository/calculator_session_repository.dart';
import 'package:tintly/features/field/bloc/field_bloc.dart';
import 'package:tintly/features/field/bloc/field_event.dart';
import 'package:tintly/features/field/repository/field_repository.dart';
import 'package:tintly/features/price/bloc/price_bloc.dart';
import 'package:tintly/features/price/bloc/price_event.dart';
import 'package:tintly/features/price/repository/price_repository.dart';
import 'package:tintly/shared/designs/dimens.dart';

class CalculatingScreen extends StatelessWidget {
  const CalculatingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String? calculatorId =
        ModalRoute.of(context)?.settings.arguments is String
        ? ModalRoute.of(context)!.settings.arguments as String
        : null;

    if (calculatorId == null) {
      return const Scaffold(
        body: Center(child: Text('Ошибка: Калькулятор не предоставлен.')),
      );
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider<FieldBloc>(
          create: (context) => FieldBloc(FieldRepository())..add(LoadFields()),
        ),
        BlocProvider<CalculatorFieldBloc>(
          create: (context) =>
              CalculatorFieldBloc(CalculatorFieldRepository())
                ..add(LoadCalculatorFieldsForSession(calculatorId)),
        ),
        BlocProvider<CalculatorSessionBloc>(
          create: (context) =>
              CalculatorSessionBloc(CalculatorSessionRepository()),
        ),
        BlocProvider(create: (_) => CalculatingBloc()),
        BlocProvider(
          create: (_) =>
              CalculatorBloc(CalculatorRepository())..add(LoadCalculators()),
        ),
        BlocProvider(
          create: (context) =>
              PriceBloc(PriceRepository())..add(LoadAllPrices()),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(title: Text('Калькулятор')),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsetsGeometry.only(
                left: Dimens.padding16,
                right: Dimens.padding16,
                bottom: 140,
              ),
              child: const CalculatingFieldsList(),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: BlocBuilder<CalculatingBloc, CalculatingState>(
                builder: (context, state) {
                  return BlocBuilder<CalculatorBloc, CalculatorState>(
                    builder: (context, calcState) {
                      if (calcState is CalculatorInitial ||
                          calcState is CalculatorLoading) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: ElevatedButton(
                            onPressed: null,
                            child: Text("Загрузка..."),
                          ),
                        );
                      }

                      if (calcState is CalculatorsLoaded) {
                        return SaveButton(
                          total: state.total,
                          calculatorId: calculatorId,
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
