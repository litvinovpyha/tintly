import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tintly/features/admin/controllers/field_controller.dart';
import 'package:tintly/features/admin/controllers/calculator_field_controller.dart';
import 'package:tintly/features/admin/models/calculator_field.dart';
import 'package:tintly/features/admin/views/field/calculator_field_create.dart';
import 'package:tintly/shared/designs/dimens.dart';
import 'package:tintly/shared/utils/id_generator.dart';
import 'package:tintly/shared/widgets/choice_dialog.dart';
import 'package:tintly/shared/widgets/custom_app_bar.dart';
import 'package:tintly/shared/widgets/field_card.dart';

class CalculatorFieldSelectList extends StatefulWidget {
  const CalculatorFieldSelectList({super.key, required this.calculatorId});
  final String calculatorId;

  @override
  State<CalculatorFieldSelectList> createState() =>
      _CalculatorFieldSelectListState();
}

class _CalculatorFieldSelectListState extends State<CalculatorFieldSelectList> {
  @override
  Widget build(BuildContext context) {
    final fieldController = Provider.of<FieldController>(
      context,
      listen: false,
    );

    return Scaffold(
      appBar: CustomAppBar(title: 'Выбор:'),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CalculatorFieldCreate()),
          );

          if (result == true) {
            setState(() {});
          }
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder(
        future: fieldController.getAll(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.hasError) {
            return Scaffold(
              body: Center(child:  Text("Ошибка: ${snapshot.error}")),
            );
          }

          final fields = snapshot.data ?? [];
          return ListView.separated(
            itemCount: fields.length,
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(height: Dimens.height8);
            },
            itemBuilder: (context, index) {
              final field = fields[index];
              return Padding(
                padding: const EdgeInsets.only(
                  left: Dimens.padding24,
                  right: Dimens.padding24,
                ),
                child: FieldCard(
                  onTapConfirm: () async {
                    final calculatorFieldController =
                        Provider.of<CalculatorFieldController>(
                          context,
                          listen: false,
                        );
                    await calculatorFieldController.create(
                      CalculatorField(
                        id: IdGenerator.generate(),
                        calculatorId: widget.calculatorId,
                        fieldId: field.id,
                        isActive: true,
                        position: 0,
                      ),
                    );

                    Navigator.pop(context, field);
                  },
                  field: field,

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
                      await fieldController.delete(field.id);
                      setState(() {});
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
