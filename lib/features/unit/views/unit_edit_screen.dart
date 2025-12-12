import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tintly/features/unit/bloc/unit_bloc.dart';
import 'package:tintly/features/unit/bloc/unit_event.dart';
import 'package:tintly/features/unit/repository/unit_repository.dart';
import 'package:tintly/features/unit/views/unit_list.dart';
import 'package:tintly/shared/designs/dimens.dart';
import 'package:tintly/shared/widgets/edit_dialog.dart';

class UnitEditScreen extends StatelessWidget {
  const UnitEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UnitBloc(UnitRepository())..add(LoadUnits()),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(title: Text('Редактирование')),
            body: Padding(
              padding: EdgeInsetsGeometry.only(bottom: Dimens.height52),
              child: UnitList(),
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
                  context.read<UnitBloc>().add(CreateUnitByName(name));
                }
              },
            ),
          );
        },
      ),
    );
  }
}
