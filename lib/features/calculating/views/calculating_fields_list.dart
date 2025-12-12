import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tintly/features/calculating/bloc/calculating_bloc.dart';
import 'package:tintly/features/calculating/bloc/calculating_event.dart';
import 'package:tintly/features/calculatorField/bloc/calculator_field_bloc.dart';
import 'package:tintly/features/calculatorField/bloc/calculator_field_event.dart';
import 'package:tintly/features/calculatorField/bloc/calculator_field_state.dart';
import 'package:tintly/features/field/bloc/field_bloc.dart';
import 'package:tintly/features/field/bloc/field_state.dart';
import 'package:tintly/features/field/models/field.dart';
import 'package:tintly/features/price/views/drop_down.dart';
import 'package:tintly/features/price/models/price.dart';
import 'package:tintly/shared/designs/dimens.dart';

class CalculatingFieldsList extends StatefulWidget {
  const CalculatingFieldsList({super.key});
  @override
  State<CalculatingFieldsList> createState() => _CalculatingFieldsListState();
}

class _CalculatingFieldsListState extends State<CalculatingFieldsList> {
  Map<String, bool> switchValues = {};
  Map<String, Price?> selectedPrices = {};
  Map<String, double> inputValues = {}; // fieldId → int input

  @override
  Widget build(BuildContext context) {
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
          return Padding(
            padding: const EdgeInsets.only(
              left: Dimens.padding16,
              right: Dimens.padding16,
              bottom: Dimens.padding120,
            ),
            child: ListView.builder(
              itemCount: calculatorFields.length,
              itemBuilder: (context, index) {
                final calculatorField = calculatorFields[index];

                Field? field;

                try {
                  field = fieldState.fields.firstWhere(
                    (f) => f.id == calculatorField.fieldId,
                  );
                  final fieldId = field.id;

                  switchValues.putIfAbsent(fieldId, () => false);
                  selectedPrices.putIfAbsent(fieldId, () => null);
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

                return Container(
                  child: field.isChecked == false
                      ? Card(
                          elevation: Dimens.elevation006,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(Dimens.padding8),
                            child: TextField(
                              textCapitalization: TextCapitalization.words,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    signed: false,
                                  ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]'),
                                ),
                              ],

                              onChanged: (value) {
                                final currentPrice = selectedPrices[field!.id];
                                if (currentPrice == null) return;

                                final oldValue = inputValues[field.id] ?? 0;
                                final newValue = int.tryParse(value) ?? 0;

                                inputValues[field.id] = newValue.toDouble();

                                final oldContribution =
                                    oldValue * currentPrice.pricePerUnit;

                                final newContribution =
                                    newValue * currentPrice.pricePerUnit;

                                final delta = newContribution - oldContribution;

                                context.read<CalculatingBloc>().add(
                                  UpdateTotal(delta),
                                );
                              },

                              decoration: InputDecoration(
                                hintText: field.name,
                                filled: false,
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 18,
                                ),
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.only(
                                    right: Dimens.padding8,
                                  ),
                                  child: DropDown(
                                    field: field,
                                    showAddIcon: false,
                                    onChanged: (newPrice) {
                                      if (newPrice == null) return;

                                      final oldPrice =
                                          selectedPrices[field!.id];
                                      selectedPrices[field.id] = newPrice;

                                      final inputValue =
                                          inputValues[field.id] ?? 0;

                                      final oldContribution =
                                          inputValue *
                                          (oldPrice?.pricePerUnit ?? 0);

                                      final newContribution =
                                          inputValue * newPrice.pricePerUnit;

                                      final delta =
                                          newContribution - oldContribution;

                                      context.read<CalculatingBloc>().add(
                                        UpdateTotal(delta),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : Card(
                          elevation: Dimens.elevation006,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(Dimens.padding8),
                            child: Row(
                              children: [
                                Expanded(child: Text(field.name)),
                                CupertinoSwitch(
                                  value: switchValues[field.id]!,
                                  onChanged: (value) {
                                    setState(
                                      () => switchValues[field!.id] = value,
                                    );

                                    final price = selectedPrices[field!.id];
                                    if (price == null) return;

                                    final delta = value
                                        ? price.pricePerUnit *
                                              1 // включили → прибавляем
                                        : -price.pricePerUnit *
                                              1; // выключили → вычитаем

                                    context.read<CalculatingBloc>().add(
                                      UpdateTotal(delta),
                                    );
                                  },
                                ),

                                DropDown(
                                  field: field,
                                  showAddIcon: false,
                                  onChanged: (newPrice) {
                                    if (newPrice == null) return;

                                    final oldPrice = selectedPrices[field!.id];
                                    selectedPrices[field.id] = newPrice;

                                    if (switchValues[field.id] == true) {
                                      final delta =
                                          (newPrice.pricePerUnit -
                                              (oldPrice?.pricePerUnit ?? 0)) *
                                          1;
                                      context.read<CalculatingBloc>().add(
                                        UpdateTotal(delta),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                );
              },
            ),
          );
        }

        return const Center(child: Text('Инициализация...'));
      },
    );
  }
}
