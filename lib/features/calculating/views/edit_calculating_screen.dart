import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tintly/features/calculatorField/bloc/calculator_field_bloc.dart';
import 'package:tintly/features/calculatorField/bloc/calculator_field_event.dart';
import 'package:tintly/features/calculatorField/repository/calculator_field_repository.dart';
import 'package:tintly/features/calculatorField/views/calculator_field_list.dart';
import 'package:tintly/features/field/bloc/field_bloc.dart';
import 'package:tintly/features/field/bloc/field_event.dart';
import 'package:tintly/features/field/repository/field_repository.dart';
import 'package:tintly/features/price/bloc/price_bloc.dart';
import 'package:tintly/features/price/bloc/price_event.dart';
import 'package:tintly/features/price/repository/price_repository.dart';
import 'package:tintly/shared/designs/dimens.dart';

class EditCalculatingScreen extends StatelessWidget {
  final String calculatorId;

  const EditCalculatingScreen({super.key, required this.calculatorId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CalculatorFieldBloc>(
          create: (context) =>
              CalculatorFieldBloc(CalculatorFieldRepository())
                ..add(LoadCalculatorFieldsForSession(calculatorId)),
        ),
        BlocProvider<FieldBloc>(
          create: (_) => FieldBloc(FieldRepository())..add(LoadFields()),
        ),
        BlocProvider(
          create: (context) =>
              PriceBloc(PriceRepository())..add(LoadAllPrices()),
        ),
      ],

      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(title: Text('Выбранные поля')),
            body: Padding(
              padding: const EdgeInsets.only(
                left: Dimens.padding16,
                right: Dimens.padding16,
                bottom: Dimens.padding120,
              ),
              child: CalculatorFieldList(),
            ),
            floatingActionButton: FloatingActionButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Dimens.radius10),
              ),

              backgroundColor: const Color(0xFFF8F9FE),
              elevation: Dimens.elevation006,
              child: const Icon(Icons.add, color: Color(0xFF2F3036)),
              onPressed: () async {
                await Navigator.pushNamed(
                  context,
                  '/field',
                  arguments: calculatorId,
                );

                if (context.mounted) {
                  context.read<CalculatorFieldBloc>().add(
                    LoadCalculatorFieldsForSession(calculatorId),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
