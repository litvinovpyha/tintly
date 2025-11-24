import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tintly/features/admin/controllers/calculator_field_controller.dart';
import 'package:tintly/features/admin/controllers/calculator_session_controller.dart';
import 'package:tintly/features/admin/models/calculator.dart';
import 'package:tintly/features/admin/views/field/calculator_field_select_list.dart';
import 'package:tintly/shared/designs/dimens.dart';
import 'package:tintly/shared/utils/size_utils.dart';
import 'package:tintly/shared/widgets/choice_dialog.dart';
import 'package:tintly/shared/widgets/custom_app_bar.dart';
import 'package:tintly/shared/widgets/field_card.dart';

class CalculatorAdminPage extends StatefulWidget {
  final Calculator calculator;
  const CalculatorAdminPage({super.key, required this.calculator});

  @override
  State<CalculatorAdminPage> createState() => _CalculatorAdminPageState();
}

class _CalculatorAdminPageState extends State<CalculatorAdminPage> {
  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<CalculatorSessionController>(
      context,
      listen: false,
    );

    return Scaffold(
      appBar: CustomAppBar(title: "Редактирование: ${widget.calculator.name}"),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  CalculatorFieldSelectList(calculatorId: widget.calculator.id),
            ),
          );
          if (result != null) {
            setState(() {});
          }
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder(
        future: controller.getAll(widget.calculator.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print(snapshot);
            return Center(child: Text("Ошибка Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Нет данных"));
          } else {
            final items = snapshot.data ?? [];
            final calculatorFieldController =
                Provider.of<CalculatorFieldController>(context, listen: false);
            return ReorderableListView.builder(
              padding: EdgeInsets.only(
                left: Dimens.padding24,
                right: Dimens.padding24,
                bottom: getListBottomPadding(context),
              ),

              itemCount: items.length,
              onReorder: (oldIndex, newIndex) async {
                if (newIndex > oldIndex) newIndex -= 1;
                final movedItem = items.removeAt(oldIndex);
                items.insert(newIndex, movedItem);
                final calculatorFields = items
                    .map((e) => e.calculatorField)
                    .toList();
                await calculatorFieldController.updatePositions(
                  widget.calculator.id,
                  calculatorFields,
                );

                setState(() {});
              },

              itemBuilder: (context, index) {
                final item = items[index];
                return FieldCard(
                  key: ValueKey(item.calculatorField.id),
                  field: item.field,
                  calculatorField: item.calculatorField,
                  onDelete: () async {
                    bool? confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => ChoiceDialog(
                        title: 'Удалить',
                        description:
                            'Вы уверены? После подтверждения данное поле будет невозможно выбрать.',
                        confirm: 'Подтвердить',
                      ),
                    );
                    if (confirm == true) {
                      await calculatorFieldController.delete(
                        item.calculatorField.id,
                      );
                      setState(() {});
                    }
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
