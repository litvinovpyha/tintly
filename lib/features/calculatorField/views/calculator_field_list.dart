import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tintly/features/calculatorField/bloc/calculator_field_bloc.dart';
import 'package:tintly/features/calculatorField/bloc/calculator_field_event.dart';
import 'package:tintly/features/calculatorField/bloc/calculator_field_state.dart';
import 'package:tintly/features/field/bloc/field_bloc.dart';
import 'package:tintly/features/field/bloc/field_state.dart';
import 'package:tintly/features/field/models/field.dart';
import 'package:tintly/features/price/bloc/price_bloc.dart';
import 'package:tintly/features/price/bloc/price_state.dart';
import 'package:tintly/features/price/models/price.dart';
import 'package:tintly/shared/designs/dimens.dart';
import 'package:tintly/shared/widgets/choice_dialog.dart';

class CalculatorFieldList extends StatefulWidget {
  const CalculatorFieldList({super.key});

  @override
  State<CalculatorFieldList> createState() => _CalculatorFieldListState();
}

class _CalculatorFieldListState extends State<CalculatorFieldList> {
  @override
  Widget build(BuildContext context) {
    bool check = false;

    final fieldState = context.watch<FieldBloc>().state;

    if (fieldState is! FieldsLoaded) {
      return const Center(
        child: CupertinoActivityIndicator(
          radius: 20.0,
          color: CupertinoColors.activeBlue,
        ),
      );
    }

    return BlocBuilder<CalculatorFieldBloc, CalculatorFieldState>(
      builder: (context, state) {
        if (state is CalculatorFieldLoading) {
          return const Center(
            child: CupertinoActivityIndicator(
              radius: 20.0,
              color: CupertinoColors.activeBlue,
            ),
          );
        } else if (state is CalculatorFieldError) {
          return Center(child: Text('Ошибка: ${state.message}'));
        } else if (state is CalculatorFieldsLoaded) {
          final calculatorFields = state.calculatorFields;
          if (calculatorFields.isEmpty) {
            return const Center(child: Text('Пусто. Добавьте новые поля'));
          }

          return ReorderableListView.builder(
            onReorder: (oldIndex, newIndex) {
              if (newIndex > oldIndex) newIndex -= 1;

              context.read<CalculatorFieldBloc>().add(
                ReorderCalculatorFields(oldIndex, newIndex),
              );
            },
            itemCount: calculatorFields.length,
            itemBuilder: (context, index) {
              final calculatorField = calculatorFields[index];

              Field? field;
              try {
                field = fieldState.fields.firstWhere(
                  (f) => f.id == calculatorField.fieldId,
                );
              } catch (_) {
                field = null;
              }

              if (field == null) {
                context.read<CalculatorFieldBloc>().add(
                  DeleteCalculatorField(calculatorField.id),
                );

                return ListTile(
                  key: ValueKey("missing_${calculatorField.id}"),
                  title: Text("Поле отсутствует"),
                  subtitle: Text("ID: ${calculatorField.fieldId}"),
                );
              }
              List<Price> pricesForField = [];

              final priceState = context.watch<PriceBloc>().state;

              if (priceState is PriceLoaded) {
                pricesForField = priceState.price
                    .where((p) => p.field == field)
                    .toList();
              }

              return Container(
                key: ValueKey(calculatorField.id),
                child: field.isChecked
                    ? Card(
                        elevation: Dimens.elevation006,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(Dimens.padding16),
                          child: Row(
                            children: [
                              Expanded(child: Text(field.name)),
                              CupertinoSwitch(
                                value: check,
                                onChanged: (value) {
                                  check = value;
                                },
                              ),
                              InkWell(
                                onTap: () async {
                                  bool? confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => ChoiceDialog(
                                      title: 'Удалить',
                                      description:
                                          'Это поле будет удалено из данного списка, но его можно будет выбрать заново.',
                                      confirm: 'Удалить',
                                    ),
                                  );
                                  if (confirm == true && context.mounted) {
                                    context.read<CalculatorFieldBloc>().add(
                                      DeleteCalculatorField(calculatorField.id),
                                    );
                                  }
                                },
                                child: Icon(Icons.delete),
                              ),
                              InkWell(
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  '/price',
                                  arguments: field,
                                ),
                                child: Icon(Icons.add, color: Colors.blue),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(
                        key: ValueKey(calculatorField.id),
                        child: Card(
                          color: Colors.white,
                          child: SizedBox(
                            height: Dimens.height52,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(child: Text(field.name)),
                                  InkWell(
                                    onTap: () async {
                                      bool? confirm = await showDialog<bool>(
                                        context: context,
                                        builder: (context) => ChoiceDialog(
                                          title: 'Удалить',
                                          description:
                                              'Это поле будет удалено из данного списка, но его можно будет выбрать заново.',
                                          confirm: 'Удалить',
                                        ),
                                      );
                                      if (confirm == true && context.mounted) {
                                        context.read<CalculatorFieldBloc>().add(
                                          DeleteCalculatorField(
                                            calculatorField.id,
                                          ),
                                        );
                                      }
                                    },
                                    child: Icon(Icons.delete),
                                  ),
                                  InkWell(
                                    onTap: () => Navigator.pushNamed(
                                      context,
                                      '/price',
                                      arguments: field,
                                    ),
                                    child: Icon(Icons.add, color: Colors.blue),
                                  ),
                                ],
                              ),
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
