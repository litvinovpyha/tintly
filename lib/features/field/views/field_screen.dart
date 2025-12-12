import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tintly/features/calculatorField/bloc/calculator_field_bloc.dart';
import 'package:tintly/features/calculatorField/repository/calculator_field_repository.dart';
import 'package:tintly/features/field/bloc/field_bloc.dart';
import 'package:tintly/features/field/bloc/field_event.dart';
import 'package:tintly/features/field/repository/field_repository.dart';
import 'package:tintly/features/field/views/field_list.dart';
import 'package:tintly/shared/designs/dimens.dart';

class FieldScreen extends StatefulWidget {
  final String calculatorId;

  const FieldScreen({super.key, required this.calculatorId});
  @override
  State<FieldScreen> createState() => _FieldScreenState();
}

class _FieldScreenState extends State<FieldScreen> {
  late FieldBloc _fieldBloc;

  @override
  void initState() {
    super.initState();
    _fieldBloc = FieldBloc(FieldRepository())..add(LoadFields());
  }

  @override
  void dispose() {
    _fieldBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FieldBloc>.value(value: _fieldBloc),
        BlocProvider(
          create: (context) => CalculatorFieldBloc(CalculatorFieldRepository()),
        ),
      ],
      child: Scaffold(
        appBar:  AppBar(title: Text('Нажмите на поле для выбора')),
        body: Padding(
          padding: const EdgeInsets.only(
            left: Dimens.padding8,
            right: Dimens.padding8,
            bottom: Dimens.padding80,
          ),
          child: FieldList(calculatorId: widget.calculatorId),
        ),
        floatingActionButton: Builder(
          builder: (context) {
            return FloatingActionButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Dimens.radius10),
              ),
              backgroundColor: const Color(0xFFF8F9FE),
              elevation: Dimens.elevation006,
              child: const Icon(Icons.add, color: Color(0xFF2F3036)),
              onPressed: () async {
                await Navigator.pushNamed(context, '/field/create');

                if (context.mounted) {
                  context.read<FieldBloc>().add(LoadFields());
                }
              },
            );
          },
        ),
      ),
    );
  }
}
