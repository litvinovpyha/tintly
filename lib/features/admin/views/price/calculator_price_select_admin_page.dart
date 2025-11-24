import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tintly/shared/utils/currency_formatter.dart';
import 'package:tintly/shared/widgets/choice_dialog.dart';
import 'package:tintly/shared/widgets/custom_app_bar.dart';
import 'package:tintly/shared/widgets/dialog/edit_dialog.dart';
import '../../models/field.dart';
import '../../../products/models/price.dart';
import '../../../products/controllers/price_controller.dart';
import 'price_admin_create.dart';

class PriceSelectionAdminPage extends StatefulWidget {
  final Field field;
  const PriceSelectionAdminPage({super.key, required this.field});

  @override
  State<PriceSelectionAdminPage> createState() =>
      _PriceSelectionAdminPageState();
}

class _PriceSelectionAdminPageState extends State<PriceSelectionAdminPage> {
  late Future<List<Price>> _pricesFuture;

  @override
  void initState() {
    super.initState();
    final priceController = Provider.of<PriceController>(
      context,
      listen: false,
    );
    _pricesFuture = priceController.getByField(widget.field.id);
  }

  void _refresh() {
    final priceController = Provider.of<PriceController>(
      context,
      listen: false,
    );
    setState(() {
      _pricesFuture = priceController.getByField(widget.field.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final priceController = Provider.of<PriceController>(
      context,
      listen: false,
    );
    return Scaffold(
      appBar: CustomAppBar(title: 'Выбор'),
      body: FutureBuilder<List<Price>>(
        future: _pricesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child:  Text("Ошибка: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: const Text("Нет Цен"));
          }

          final prices = snapshot.data!;

          return ListView.separated(
            itemCount: prices.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final price = prices[index];
              return GestureDetector(
                child: ListTile(
                  leading: InkWell(
                    onTap: () async {
                      final value = await showDialog(
                        context: context,
                        builder: (context) {
                          return EditDialog(
                            label: 'Редактировать цену:',
                            description: '',
                            confirm: 'Сохранить',
                            data: price.pricePerUnit.toStringAsFixed(0),
                          );
                        },
                      );
                      final newPrice = double.tryParse(value);

                      if (newPrice == null) return;
                      final updatedPrice = Price(
                        id: price.id,
                        brand: price.brand,
                        field: price.field,
                        pricePerUnit: newPrice,
                        placeholder: price.placeholder,
                      );

                      await priceController.update(updatedPrice);
                      _refresh();
                    },
                    child: const Icon(Icons.edit),
                  ),
                  trailing: InkWell(
                    onTap: () async {
                      bool? confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => ChoiceDialog(
                          title: 'Удалить',
                          description:
                              'Вы уверены? после подтверждения поле будет удалено',
                          confirm: 'Удалить',
                        ),
                      );
                      if (confirm == true) {
                        await priceController.delete(price);
                        _refresh();
                      }
                    },
                    child: Icon(Icons.delete_outlined),
                  ),
                  title:  Text(price.brand.name),
                  subtitle:  Text(
                    "Цена: ${CurrencyFormatter.format(price.pricePerUnit)}",
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreatePricePage(field: widget.field),
            ),
          );

          if (result == true) {
            _refresh();
            Navigator.pop(context, true);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
