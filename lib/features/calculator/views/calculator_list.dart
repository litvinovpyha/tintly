import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tintly/features/calculator/bloc/calculator_bloc.dart';
import 'package:tintly/features/calculator/bloc/calculator_event.dart';
import 'package:tintly/features/calculator/bloc/calculator_state.dart';
import 'package:tintly/shared/designs/dimens.dart';
import 'package:tintly/shared/designs/styles.dart';
import 'package:tintly/shared/widgets/choice_dialog.dart';
import 'package:tintly/shared/widgets/edit_dialog.dart';

class CalculatorList extends StatelessWidget {
  const CalculatorList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalculatorBloc, CalculatorState>(
      builder: (context, state) {
        if (state is CalculatorLoading) {
          return const Center(
            child: CupertinoActivityIndicator(
              radius: 20.0,
              color: CupertinoColors.activeBlue,
            ),
          );
        } else if (state is CalculatorError) {
          return Center(child: Text('Ошибка: ${state.message}'));
        } else if (state is CalculatorsLoaded) {
          if (state.calculators.isEmpty) {
            return const Center(child: Text('Нет доступных единиц.'));
          }
          return ListView.builder(
            itemCount: state.calculators.length,
            itemBuilder: (context, index) {
              final calculator = state.calculators[index];
              return Card(
                color: Colors.transparent,
                elevation: Dimens.elevation0,
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/settings/edit/calculator/edit',
                      arguments: calculator.id,
                    );
                  },
                  child: SizedBox(
                    height: Dimens.height72,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: Dimens.padding16,
                        right: Dimens.padding16,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              calculator.name,
                              style: headingH5TextStyle,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          InkWell(
                            child: Icon(Icons.edit),
                            onTap: () async {
                              final newName = await showDialog(
                                context: context,
                                builder: (context) {
                                  return EditDialog(
                                    label: 'Редактировать Название:',
                                    description: '',
                                    confirm: 'Сохранить',
                                    data: calculator.name,
                                  );
                                },
                              );

                              if (newName != null && context.mounted) {
                                context.read<CalculatorBloc>().add(
                                  UpdateCalculatorByName(
                                    calculator.id,
                                    newName,
                                  ),
                                );
                              }
                            },
                          ),
                          InkWell(
                            child: Icon(Icons.delete_outline),
                            onTap: () async {
                              bool? confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => ChoiceDialog(
                                  title: 'Удалить',
                                  description: 'Вы уверены?',
                                  confirm: 'Удалить',
                                ),
                              );

                              if (confirm == true && context.mounted) {
                                context.read<CalculatorBloc>().add(
                                  DeleteCalculator(calculator.id),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
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
