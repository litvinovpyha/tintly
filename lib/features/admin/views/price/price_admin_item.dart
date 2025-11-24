import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tintly/features/admin/models/calculator_field.dart';
import 'package:tintly/features/admin/controllers/calculator_state.dart';
import 'package:tintly/features/admin/models/field.dart';
import 'package:tintly/features/admin/views/price/calculator_price_select_admin_page.dart';
import 'package:tintly/features/products/controllers/price_controller.dart';
import 'package:tintly/features/products/models/price.dart';

class PriceAdminDropDown extends StatefulWidget {
  final Field field;
  final CalculatorField calculatorField;

  const PriceAdminDropDown({
    super.key,
    required this.field,
    required this.calculatorField,
  });

  @override
  _PriceAdminDropDownState createState() => _PriceAdminDropDownState();
}

class _PriceAdminDropDownState extends State<PriceAdminDropDown> {
  late Future<List<Price>> _pricesFuture;
  String? selectedBrandId;

  @override
  void initState() {
    super.initState();
    final priceController = Provider.of<PriceController>(
      context,
      listen: false,
    );
    _pricesFuture = priceController.getByField(widget.field.id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Price>>(
      future: _pricesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return  Text('Ошибка: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return InkWell(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PriceSelectionAdminPage(field: widget.field),
                ),
              );
              if (result != null) {
                setState(() {
                  final priceController = Provider.of<PriceController>(
                    context,
                    listen: false,
                  );
                  _pricesFuture = priceController.getByField(widget.field.id);
                });
              }
            },
            child: const Icon(Icons.add),
          );
        }

        final prices = snapshot.data!;
        final brands = {
          for (var p in prices) p.brand.id: p.brand,
        }.values.toList();

        if (selectedBrandId == null ||
            !brands.any((b) => b.id == selectedBrandId)) {
          selectedBrandId = brands.first.id;

          final defaultPrice = prices.firstWhere(
            (p) => p.brand.id == selectedBrandId,
          );

          WidgetsBinding.instance.addPostFrameCallback((_) {
            Provider.of<CalculatorState>(
              context,
              listen: false,
            ).setPrice(widget.calculatorField.id, defaultPrice.pricePerUnit);
          });
        }

        return DropdownButton<String>(
          padding: const EdgeInsets.only(),
          underline: const SizedBox.shrink(),
          icon: const SizedBox.shrink(),
          value: selectedBrandId,
          onChanged: (String? newValue) async {
            if (newValue == "-1") {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PriceSelectionAdminPage(field: widget.field),
                ),
              );

              if (result != null) {
                setState(() {
                  final priceController = Provider.of<PriceController>(
                    context,
                    listen: false,
                  );
                  _pricesFuture = priceController.getByField(widget.field.id);
                });
              }
            } else if (newValue != null) {
              final selectedPrice = prices.firstWhere(
                (p) => p.brand.id == newValue,
              );

              Provider.of<CalculatorState>(
                context,
                listen: false,
              ).setPrice(widget.calculatorField.id, selectedPrice.pricePerUnit);

              setState(() {
                selectedBrandId = newValue;
              });
            }
          },
          items: [
            ...brands.map((brand) {
              return DropdownMenuItem<String>(
                alignment: Alignment.center,
                value: brand.id.toString(),
                child: (brand.imageUrl != null && brand.imageUrl!.isNotEmpty)
                    ? Image.asset(
                        brand.imageUrl!,
                        width: 32,
                        height: 32,
                        fit: BoxFit.cover,
                      )
                    : const Icon(
                        Icons.image_not_supported,
                        size: 32,
                        color: Colors.grey,
                      ),
              );
            }),
            const DropdownMenuItem<String>(
              value: "-1",
              alignment: Alignment.center,
              child: Icon(Icons.add, size: 32),
            ),
          ],
        );
      },
    );
  }
}
