import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tintly/features/admin/views/brand/calculator_brand_admin_create.dart';
import 'package:tintly/shared/designs/app_color.dart';
import 'package:tintly/shared/designs/dimens.dart';
import 'package:tintly/shared/widgets/custom_app_bar.dart';
import '../../../products/models/price.dart';
import '../../../products/models/brand.dart';
import '../../models/field.dart';
import '../../../products/controllers/brand_controller.dart';
import '../../../products/controllers/price_controller.dart';
import '../../../../shared/utils/id_generator.dart';

class CreatePricePage extends StatefulWidget {
  final Field field;

  const CreatePricePage({super.key, required this.field});

  @override
  State<CreatePricePage> createState() => _CreatePricePageState();
}

class _CreatePricePageState extends State<CreatePricePage> {
  final _formKey = GlobalKey<FormState>();

  String? selectedBrandId;
  Brand? selectedBrand;
  final TextEditingController _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BrandController>(context, listen: false).loadItems();
    });
  }

  Future<void> _save() async {
    if (_formKey.currentState!.validate() && selectedBrand != null) {
      final price = Price(
        id: IdGenerator.generate(),
        brand: selectedBrand!,
        field: widget.field,
        pricePerUnit: double.parse(_priceController.text),
        placeholder:
            '${double.parse(_priceController.text)}тг${selectedBrand!}',
      );

      try {
        final priceController = Provider.of<PriceController>(
          context,
          listen: false,
        );
        await priceController.create(price);

        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content:  Text("Ошибка при сохранении: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Создать прайс'),
      body: Consumer<BrandController>(
        builder: (context, brandController, child) {
          if (brandController.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final brands = brandController.items;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: "Бренд"),
                    items: brands.map((b) {
                      return DropdownMenuItem(
                        value: b.id.toString(),
                        child: Row(
                          children: [
                            CircleAvatar(child: Image.asset(b.imageUrl ?? '')),
                             Text(b.name),
                          ],
                        ),
                      );
                    }).toList(),
                    initialValue: selectedBrandId,
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          selectedBrand = brands.firstWhere(
                            (b) => b.id.toString() == val,
                          );
                          selectedBrandId = val;
                        });
                      }
                    },
                    validator: (val) => val == null ? "Выберите бренд" : null,
                  ),
                  TextFormField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Цена за единицу",
                    ),
                    validator: (val) =>
                        val == null || val.isEmpty ? "Введите цену" : null,
                  ),

                  ElevatedButton(
                    onPressed: _save,
                    child: const Text("Сохранить"),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateBrandPage()),
          );
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            Dimens.radius10,
          ), // ← Изменяем радиус
        ),

        backgroundColor: Color(0xFFF8F9FE),
        elevation: Dimens.elevation006,
        child: Icon(Icons.add, color: AppColor.primaryColor),
      ),
    );
  }
}
