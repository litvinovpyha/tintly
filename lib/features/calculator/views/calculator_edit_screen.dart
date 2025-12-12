import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tintly/features/calculator/bloc/calculator_bloc.dart';
import 'package:tintly/features/calculator/bloc/calculator_event.dart';
import 'package:tintly/features/calculator/repository/calculator_repository.dart';
import 'package:tintly/features/calculator/views/calculator_list.dart';
import 'package:tintly/shared/designs/dimens.dart';
import 'package:tintly/shared/widgets/edit_dialog.dart';

class CalculatorEditScreen extends StatelessWidget {
  const CalculatorEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    return BlocProvider(
      create: (context) =>
          CalculatorBloc(CalculatorRepository())..add(LoadCalculators()),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(title: Text('Редактирование')),
            body: Padding(
              padding: EdgeInsetsGeometry.only(bottom: Dimens.height52),
              child: CalculatorList(),
            ),
            floatingActionButton: FloatingActionButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Dimens.radius10),
              ),

              backgroundColor: Color(0xFFF8F9FE),
              elevation: Dimens.elevation006,
              child: Icon(Icons.add, color: Color(0xFF2F3036)),
              onPressed: () async {
                final name = await showDialog<String>(
                  context: context,
                  builder: (context) {
                    return const EditDialog(
                      label: 'Создать:',
                      description: '',
                      confirm: 'Создать',
                      data: "",
                    );
                  },
                );

                if (name != null && name.isNotEmpty && context.mounted) {
                  context.read<CalculatorBloc>().add(
                    CreateCalculatorByName('0', name),
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
