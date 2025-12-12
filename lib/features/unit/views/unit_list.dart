import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tintly/features/unit/bloc/unit_bloc.dart';
import 'package:tintly/features/unit/bloc/unit_event.dart';
import 'package:tintly/features/unit/bloc/unit_state.dart';
import 'package:tintly/shared/designs/dimens.dart';
import 'package:tintly/shared/designs/styles.dart';
import 'package:tintly/shared/widgets/choice_dialog.dart';
import 'package:tintly/shared/widgets/edit_dialog.dart';

class UnitList extends StatelessWidget {
  const UnitList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UnitBloc, UnitState>(
      builder: (context, state) {
        if (state is UnitLoading) {
          return const Center(
            child: CupertinoActivityIndicator(
              radius: 20.0,
              color: CupertinoColors.activeBlue,
            ),
          );
        } else if (state is UnitError) {
          return Center(child: Text('Ошибка: ${state.message}'));
        } else if (state is UnitLoaded) {
          if (state.units.isEmpty) {
            return const Center(child: Text('Нет доступных единиц.'));
          }
          return ListView.builder(
            itemCount: state.units.length,
            itemBuilder: (context, index) {
              final unit = state.units[index];
              return Card(
                color: Colors.transparent,
                elevation: Dimens.elevation0,
                child: InkWell(
                  onTap: () {},
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
                              unit.name,
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
                                    data: unit.name,
                                  );
                                },
                              );

                              if (newName != null && context.mounted) {
                                context.read<UnitBloc>().add(
                                  UpdateUnitByName(unit.id, newName),
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
                                context.read<UnitBloc>().add(
                                  DeleteUnit(unit.id),
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
