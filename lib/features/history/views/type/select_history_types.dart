import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tintly/features/admin/controllers/calculator_controller.dart';
import 'package:tintly/features/admin/models/calculator.dart';
import 'package:tintly/shared/designs/dimens.dart';
import 'package:tintly/shared/designs/icons.dart';
import 'package:tintly/shared/widgets/custom_app_bar.dart';
import 'package:tintly/shared/widgets/custom_list_tile.dart';

class SelectHistoryTypes extends StatefulWidget {
  const SelectHistoryTypes({super.key});

  @override
  State<SelectHistoryTypes> createState() => _SelectHistoryTypesState();
}

class _SelectHistoryTypesState extends State<SelectHistoryTypes> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await context.read<CalculatorController>().loadItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.watch<CalculatorController>();

    return Scaffold(
      appBar: CustomAppBar(title: 'Фильтр'),
      body: Padding(
        padding: const EdgeInsetsGeometry.all(Dimens.padding16),
        child: c.isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: c.items.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return CustomListTile(
                      title: 'Все типы',
                      trailing: chevronRight,
                      onTap: () {
                        final item = Calculator(
                          id: 'Все',
                          userId: 'Все',
                          name: 'Все',
                          placeholder: 'Все',
                          isActive: true,
                        );
                        Navigator.pop(context, item);
                      },
                    );
                  }
                  final i = c.items[index - 1];
                  return CustomListTile(
                    title: i.name,
                    trailing: chevronRight,
                    onTap: () {
                      Navigator.pop(context, i);
                    },
                  );
                },
              ),
      ),
    );
  }
}
