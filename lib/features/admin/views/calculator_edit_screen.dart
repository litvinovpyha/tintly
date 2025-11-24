import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tintly/features/admin/controllers/calculator_controller.dart';
import 'package:tintly/features/admin/models/calculator.dart';
import 'package:tintly/shared/designs/dimens.dart';
import 'package:tintly/shared/widgets/choice_dialog.dart';
import 'package:tintly/shared/widgets/custom_app_bar.dart';
import 'package:tintly/shared/widgets/custom_list_tile.dart';
import 'package:tintly/shared/widgets/dialog/edit_dialog.dart';

class CalculatorEditScreen extends StatefulWidget {
  const CalculatorEditScreen({super.key});

  @override
  State<CalculatorEditScreen> createState() => _CalculatorEditScreenState();
}

class _CalculatorEditScreenState extends State<CalculatorEditScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await context.read<CalculatorController>().loadItems();
    });
  }

  void delete(String id) {
    Future.microtask(() async {
      await context.read<CalculatorController>().delete(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.watch<CalculatorController>();

    return Scaffold(
      appBar: CustomAppBar(title: 'Редактирование Калькулятора'),
      body: Padding(
        padding: const EdgeInsetsGeometry.all(Dimens.padding16),
        child: Stack(
          children: [
            c.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: c.items.length,
                    itemBuilder: (context, index) {
                      final i = c.items[index];
                      return CustomListTile(
                        leading: InkWell(
                          child: Icon(Icons.edit),
                          onTap: () async {
                            final value = await showDialog(
                              context: context,
                              builder: (context) {
                                return EditDialog(
                                  label: 'Редактировать цену:',
                                  description: '',
                                  confirm: 'Сохранить',
                                  data: i.name,
                                );
                              },
                            );

                            if (value == null) return;
                            final item = Calculator(
                              id: i.id,
                              name: value,
                              isActive: true,
                              placeholder: value,
                              userId: i.userId,
                            );

                            await c.update(item);
                          },
                        ),
                        title: i.name,
                        trailing: InkWell(
                          child: Icon(Icons.delete_outline),
                          onTap: () async {
                            bool? confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => ChoiceDialog(
                                title: 'Удалить',
                                description: 'Вы уверены? поле будет удалено',
                                confirm: 'Удалить',
                              ),
                            );

                            if (confirm == true) delete(i.id);
                          },
                        ),
                      );
                    },
                  ),
            Align(
              alignment: AlignmentGeometry.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(Dimens.padding24),
                child: FloatingActionButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Dimens.radius10),
                  ),

                  backgroundColor: Color(0xFFF8F9FE),
                  elevation: Dimens.elevation006,
                  child: Icon(Icons.add, color: Color(0xFF2F3036)),

                  onPressed: () async {
                    final result = await showDialog<String>(
                      context: context,
                      builder: (context) {
                        return const EditDialog(
                          label: 'Создать калькулятор:',
                          description: '',
                          confirm: 'Создать',
                          data: "",
                        );
                      },
                    );

                    if (result != null && result.isNotEmpty) {
                      final calculatorController =
                          Provider.of<CalculatorController>(
                            context,
                            listen: false,
                          );

                      await calculatorController.create(
                        Calculator(
                          id: "",
                          userId: "0",
                          name: result,
                          placeholder: result,
                          isActive: true,
                        ),
                      );
                      setState(() {});
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
//  