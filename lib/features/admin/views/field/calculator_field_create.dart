import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tintly/shared/designs/styles.dart';
import 'package:tintly/shared/widgets/custom_app_bar.dart';
import 'package:tintly/shared/widgets/dialog/edit_dialog.dart';
import '../../../../shared/designs/app_color.dart';
import '../../../../shared/designs/dimens.dart';
import '../../../../shared/widgets/dialog/error_dialog.dart';
import '../../controllers/field_controller.dart';
import '../../../products/models/unit.dart';
import '../../../products/controllers/unit_controller.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../core/result.dart';

class CalculatorFieldCreate extends StatefulWidget {
  const CalculatorFieldCreate({super.key});

  @override
  State<CalculatorFieldCreate> createState() => _CalculatorFieldCreateState();
}

class _CalculatorFieldCreateState extends State<CalculatorFieldCreate> {
  final TextEditingController _nameController = TextEditingController();
  bool _isChecked = false;

  Unit? _selectedUnit;

  @override
  Widget build(BuildContext context) {
    final unitController = Provider.of<UnitController>(context, listen: false);
    final fieldController = Provider.of<FieldController>(
      context,
      listen: false,
    );

    return FutureBuilder<Result<List<Unit>>>(
      future: unitController.unitService.getAll(),
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

        final result = snapshot.data;
        if (result == null || result.isFailure) {
          return Scaffold(
            body: Center(
              child:  Text("Ошибка: ${result?.error ?? 'Unknown error'}"),
            ),
          );
        }

        final units = result.data ?? [];

        return Scaffold(
          appBar: CustomAppBar(title: 'Создать новое поле'),
          body: Stack(
            children: [
              ListView(
                padding: const EdgeInsets.all(Dimens.padding16),
                children: [
                  _buildInputCard(
                    label: "Название",
                    hint: "Введите название.",
                    controller: _nameController,
                  ),
                  _buildUnitCard(units),
                  Card(
                    color: AppColor.surfaceColor,
                    margin: const EdgeInsets.only(bottom: Dimens.padding8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimens.radius8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(Dimens.padding8),
                      child: Row(
                        children: [
                          Checkbox(
                            value: _isChecked,
                            onChanged: (bool? value) {
                              setState(() {
                                _isChecked = value ?? false;
                              });
                            },
                          ),
                          const   Text("Отметить поле как \"ЧекБокс\""),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: PrimaryButton(
                  title: 'Сохранить',
                  onPressed: () async {
                    if (_nameController.text.isEmpty || _selectedUnit == null) {
                      _showErrorDialog(context, "Заполни все поля!");
                    } else {
                      await fieldController.createField(
                        name: _nameController.text,
                        unitId: _selectedUnit!.id,
                        placeholder: _selectedUnit!.unitName,
                        isChecked: _isChecked,
                      );
                    }
                    Navigator.pop(context, true);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInputCard({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return SizedBox(
      height: Dimens.height64,
      child: Card(
        color: AppColor.surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.radius8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimens.padding8),
          child: Center(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                hintText: hint,
                labelText: label,
                border: InputBorder.none,
              ),
              style: primaryTextStyle,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUnitCard(List<Unit> units) {
    final unitController = Provider.of<UnitController>(context, listen: false);

    return Card(
      color: AppColor.surfaceColor,
      margin: const EdgeInsets.only(bottom: Dimens.padding8),
      elevation: Dimens.elevation006,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.radius8),
      ),
      child: Padding(
        padding: const  EdgeInsets.all(Dimens.padding8),
        child: Stack(
          children: [
            Wrap(
              spacing: 8,
              children: [
                ...units.map((unit) {
                  final isSelected = _selectedUnit?.id == unit.id;
                  return ChoiceChip(
                    label:   Text(unit.unitName),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() {
                        _selectedUnit = unit;
                      });
                    },
                    selectedColor: AppColor.primaryColor,
                    labelStyle: TextStyle(
                      color: isSelected ? AppColor.surfaceColor : AppColor.blackColor,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                }),
                ActionChip(
                  avatar: const Icon(Icons.add, size: 18),
                  label: const Text("Добавить"),
                  onPressed: () async {
                    final value = await showDialog(
                      context: context,
                      builder: (context) {
                        return EditDialog(
                          label: 'Новая единица:',
                          description: '',
                          confirm: 'Создать',
                          data: '',
                        );
                      },
                    );
                    final item = Unit(
                      id: '',
                      unitName: value,
                      isActive: true,
                      placeholder: value,
                    );
//ошибка
                    if (value != null) await unitController.create(item);
                    setState(() {});
                  },
                ),
              ],
            ),
            Align(
              alignment: AlignmentGeometry.topRight,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/settings/edit/unit');
                },
                child: Icon(Icons.edit),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ErrorDialog(description: message);
      },
    );
  }
}
