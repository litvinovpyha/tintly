import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tintly/features/products/controllers/unit_controller.dart';
import 'package:tintly/features/products/models/unit.dart';
import 'package:tintly/shared/designs/dimens.dart';
import 'package:tintly/shared/widgets/choice_dialog.dart';
import 'package:tintly/shared/widgets/custom_app_bar.dart';
import 'package:tintly/shared/widgets/custom_list_tile.dart';
import 'package:tintly/shared/widgets/dialog/edit_dialog.dart';

class UnitEditScreen extends StatefulWidget {
  const UnitEditScreen({super.key});

  @override
  State<UnitEditScreen> createState() => _UnitEditScreenState();
}

class _UnitEditScreenState extends State<UnitEditScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await context.read<UnitController>().loadItems();
    });
  }

  void delete(String id) {
    Future.microtask(() async {
      await context.read<UnitController>().delete(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.watch<UnitController>();

    return Scaffold(
      appBar: CustomAppBar(title: 'Редактирование Ед. Из.'),
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
                                  data: i.unitName,
                                );
                              },
                            );

                            if (value == null) return;
                            final item = Unit(
                              id: i.id,
                              unitName: value,
                              isActive: true,
                              placeholder: value,
                            );

                            await c.update(item);
                          },
                        ),
                        title: i.unitName,
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
                          label: 'Создать Единицу:',
                          description: '',
                          confirm: 'Создать',
                          data: "",
                        );
                      },
                    );
                    if (result != null && result.isNotEmpty) {
                      final i = Unit(
                        id: '',
                        unitName: result,
                        isActive: true,
                        placeholder: result,
                      );

                      await c.create(i);
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
