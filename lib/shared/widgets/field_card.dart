import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tintly/features/calculatorField/models/calculator_field.dart';
import 'package:tintly/features/field/models/field.dart';
import 'package:tintly/shared/designs/app_color.dart';
import 'package:tintly/shared/designs/dimens.dart';
import 'package:tintly/shared/designs/styles.dart';

class FieldCard extends StatelessWidget {
  final Field field;
  final CalculatorField? calculatorField;
  final Function()? onTapConfirm;
  final Function()? onDelete;
  const FieldCard({
    super.key,
    this.onTapConfirm,
    this.onDelete,
    required this.field,
    this.calculatorField,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColor.surfaceColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTapConfirm,

        child: SizedBox(
          height: Dimens.height52,
          child: Padding(
            padding: const EdgeInsets.only(
              left: Dimens.padding16,
              right: Dimens.padding16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (field.isChecked == true)
                  CupertinoSwitch(value: true, onChanged: (value) {}),

                Expanded(
                  child: Text(
                    field.name,
                    style: darkestTextStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                InkWell(onTap: onDelete, child: Icon(Icons.delete_outlined)),
                // if (calculatorField != null)
                // PriceAdminDropDown(
                //   field: field,
                //   calculatorField: calculatorField!,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
