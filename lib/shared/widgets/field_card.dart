import 'package:flutter/material.dart';
import 'package:tintly/features/admin/models/calculator_field.dart';
import 'package:tintly/features/admin/models/field.dart';
import 'package:tintly/features/admin/views/price/price_admin_item.dart';
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
                Expanded(
                  child:  Text(
                    field.productName,
                    style: darkestTextStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (field.isChecked == true) const Text('ЧекБокс'),
                InkWell(onTap: onDelete, child: Icon(Icons.delete_outlined)),
                if (calculatorField != null)
                  PriceAdminDropDown(
                    field: field,
                    calculatorField: calculatorField!,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
