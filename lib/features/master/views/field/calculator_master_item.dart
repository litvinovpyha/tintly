import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tintly/features/master/views/price/price_master_item.dart';
import 'package:tintly/shared/designs/app_color.dart';
import 'package:tintly/shared/designs/dimens.dart';
import 'package:tintly/shared/designs/styles.dart';
import 'package:tintly/features/admin/models/calculator_field.dart';
import 'package:tintly/features/admin/models/field.dart';
import 'package:tintly/features/admin/controllers/calculator_state.dart';

class CalculatorMasterListItem extends StatefulWidget {
  const CalculatorMasterListItem({
    super.key,
    required this.field,
    required this.calculatorField,
    required this.onTap,
    required this.index,
  });

  final Field field;
  final CalculatorField calculatorField;
  final VoidCallback onTap;
  final int index;
  @override
  State<CalculatorMasterListItem> createState() =>
      _CalculatorMasterListItemState();
}

class _CalculatorMasterListItemState extends State<CalculatorMasterListItem> {
  late bool switchValue = false;

  static const WidgetStateProperty<Icon> thumbIcon =
      WidgetStateProperty<Icon>.fromMap(<WidgetStatesConstraint, Icon>{
        WidgetState.selected: Icon(Icons.check, size: 18),
        WidgetState.any: Icon(Icons.close, size: 18),
      });

  @override
  Widget build(BuildContext context) {
    return widget.field.isChecked
        ? Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child:  Text(
                      widget.field.productName,
                      style: primaryTextStyle,
                    ),
                  ),
                  Switch(
                    padding: const EdgeInsets.only(right: Dimens.padding16),
                    value: switchValue,
                    thumbIcon: thumbIcon,
                    onChanged: (value) {
                      setState(() {
                        switchValue = value;

                        final calculatorState = Provider.of<CalculatorState>(
                          context,
                          listen: false,
                        );

                        if (switchValue) {
                          calculatorState.setQuantity(
                            widget.calculatorField.id,
                            1,
                          );
                        } else {
                          calculatorState.setQuantity(
                            widget.calculatorField.id,
                            0,
                          );
                        }
                      });
                    },
                  ),

                  PriceMasterDropDown(
                    field: widget.field,
                    calculatorField: widget.calculatorField,
                  ),
                ],
              ),
            ),
          )
        : GestureDetector(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text(widget.field.productName, style: primaryTextStyle),
                const SizedBox(height: 6),
                Consumer<CalculatorState>(
                  builder: (context, calculatorState, child) {
                    final controller = calculatorState.getController(
                      widget.calculatorField.id,
                    );
                    return TextField(
                      controller: controller,
                      onTap: widget.onTap,
                      keyboardType: TextInputType.phone,
                      onChanged: (value) {
                        int qty = 0;
                        try {
                          qty = value
                              .split('+')
                              .map((part) => int.tryParse(part.trim()) ?? 0)
                              .fold(0, (a, b) => a + b);
                        } catch (_) {
                          qty = 0;
                        }

                        calculatorState.setQuantity(
                          widget.calculatorField.id,
                          qty,
                        );
                      },

                      decoration: InputDecoration(
                        hintText: widget.field.placeholder,
                        filled: true,
                        fillColor: AppColor.surfaceColor,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 18,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Dimens.radius8),
                        ),
                        suffixIcon: PriceMasterDropDown(
                          field: widget.field,
                          calculatorField: widget.calculatorField,
                        ),
                      ),
                      style: primaryTextStyle,
                    );
                  },
                ),
              ],
            ),
          );
  }
}
