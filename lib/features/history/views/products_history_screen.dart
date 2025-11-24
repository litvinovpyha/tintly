import 'package:flutter/material.dart';
import 'package:tintly/features/admin/models/calculator_session.dart';
import 'package:tintly/shared/designs/styles.dart';
import 'package:tintly/shared/widgets/custom_app_bar.dart';
import 'package:tintly/shared/widgets/custom_list_tile.dart';

class ProductsHistoryScreen extends StatefulWidget {
  const ProductsHistoryScreen({super.key});
  @override
  State<ProductsHistoryScreen> createState() => _ProductsHistoryScreenState();
}

class _ProductsHistoryScreenState extends State<ProductsHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    final List<CalculatorSession> sessions =
        ModalRoute.of(context)!.settings.arguments as List<CalculatorSession>;

    final Map<String, double> totals = {};

    for (final session in sessions) {
      session.consumptionData?.forEach((key, value) {
        totals[key] = (totals[key] ?? 0) + value;
      });
    }

    return Scaffold(
      appBar: const CustomAppBar(title: 'Статистика по продуктам'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: totals.length,
          itemBuilder: (context, index) {
            final key = totals.keys.elementAt(index);
            final value = totals.values.elementAt(index);

            return CustomListTile(
              title: key,
              subtitle: const Text('', style: darkestTextStyle),
              trailing:  Text(
                '${value.toStringAsFixed(0)} ед.',
                style: headingH5TextStyle,
              ),
            );
          },
        ),
      ),
    );
  }
}
