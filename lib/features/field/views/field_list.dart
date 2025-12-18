import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tintly/features/calculatorField/bloc/calculator_field_bloc.dart';
import 'package:tintly/features/calculatorField/bloc/calculator_field_event.dart';
import 'package:tintly/features/field/bloc/field_bloc.dart';
import 'package:tintly/features/field/bloc/field_event.dart';
import 'package:tintly/features/field/bloc/field_state.dart';
import 'package:tintly/shared/widgets/choice_dialog.dart';
import 'package:tintly/shared/widgets/edit_dialog.dart';
import 'package:tintly/shared/widgets/field_card.dart';

class FieldList extends StatelessWidget {
  final String calculatorId;
  const FieldList({super.key, required this.calculatorId});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FieldBloc, FieldState>(
      builder: (context, state) {
        if (state is FieldLoading) {
          return const Center(
            child: CupertinoActivityIndicator(
              radius: 20.0,
              color: CupertinoColors.activeBlue,
            ),
          );
        } else if (state is FieldError) {
          return Center(child: Text('Ошибка: ${state.message}'));
        } else if (state is FieldsLoaded) {
          if (state.fields.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Нет доступных единиц.'),
                  Text('Создайте новое: Например: "Краситель"'),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: state.fields.length,
            itemBuilder: (context, index) {
              final field = state.fields[index];
              return InkWell(
                onDoubleTap: () async {
                  final newPlaceholder = await showDialog(
                    context: context,
                    builder: (context) {
                      return EditDialog(
                        label: 'Редактировать Описание:',
                        description: '',
                        confirm: 'Сохранить',
                        data: field.placeholder ?? '',
                      );
                    },
                  );

                  if (newPlaceholder != null && context.mounted) {
                    context.read<FieldBloc>().add(
                      UpdateFieldByPlasholder(field.id, newPlaceholder),
                    );
                  }
                },
                onLongPress: () async {
                  final newName = await showDialog(
                    context: context,
                    builder: (context) {
                      return EditDialog(
                        label: 'Редактировать Название:',
                        description: '',
                        confirm: 'Сохранить',
                        data: field.name,
                      );
                    },
                  );

                  if (newName != null && context.mounted) {
                    context.read<FieldBloc>().add(
                      UpdateFieldByName(field.id, newName),
                    );
                  }
                },
                child: FieldCard(
                  field: field,
                  onTapConfirm: () {
                    context.read<CalculatorFieldBloc>().add(
                      CreateCalculatorField(calculatorId, field.id),
                    );
                    Navigator.pop(context);
                  },

                  onDelete: () async {
                    bool? confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => ChoiceDialog(
                        title: 'Удалить',
                        description: 'Вы уверены?',
                        confirm: 'Удалить',
                      ),
                    );

                    if (confirm == true && context.mounted) {
                      context.read<FieldBloc>().add(DeleteField(field.id));
                    }
                  },
                ),
              );

           
            },
          );
        }
        return const Center(child: Text('Инициализация...'));
      },
    );
  }
}
