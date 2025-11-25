import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tintly/app/main_screen.dart';
import 'package:tintly/features/admin/models/calculator.dart';
import 'package:tintly/features/admin/models/calculator_session.dart';
import 'package:tintly/features/admin/controllers/calculator_session_controller.dart';
import 'package:tintly/features/admin/controllers/calculator_state.dart';
import 'package:tintly/features/master/views/field/calculator_master_item.dart';
import 'package:tintly/features/master/views/select_client.dart';
import 'package:tintly/shared/designs/app_color.dart';
import 'package:tintly/shared/designs/dimens.dart';
import 'package:tintly/shared/designs/styles.dart';
import 'package:tintly/shared/utils/size_utils.dart';
import 'package:tintly/shared/widgets/custom_app_bar.dart';
import 'package:tintly/shared/widgets/primary_button.dart';
import 'package:tintly/shared/widgets/primary_button_discount.dart';

class CalculatorMasterPage extends StatefulWidget {
  final Calculator calculator;
  const CalculatorMasterPage({super.key, required this.calculator});

  @override
  State<CalculatorMasterPage> createState() => _CalculatorMasterPageState();
}

class _CalculatorMasterPageState extends State<CalculatorMasterPage> {
  List<dynamic> _items = [];

  @override
  Widget build(BuildContext context) {
    final calculatorSessionController =
        Provider.of<CalculatorSessionController>(context, listen: false);

    return ChangeNotifierProvider(
      create: (_) => CalculatorState(),
      child: Scaffold(
        appBar: CustomAppBar(title: widget.calculator.name),
        body: FutureBuilder(
          future: calculatorSessionController.getAll(widget.calculator.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (snapshot.hasError) {
              return Scaffold(
                body: Center(child: Text("Ошибка: ${snapshot.error}")),
              );
            }

            if (_items.isEmpty) {
              _items = snapshot.data ?? [];
            }

            return Stack(
              children: [
                ListView.separated(
                  itemCount: _items.length,
                  padding: EdgeInsets.only(
                    top: Dimens.padding16,
                    left: Dimens.padding16,
                    right: Dimens.padding16,
                    bottom: getListBottomPadding(context) + Dimens.height80,
                  ),
                  separatorBuilder: (context, index) =>
                      SizedBox(height: Dimens.height8),
                  itemBuilder: (context, index) {
                    final item = _items[index];
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      final calculatorState = Provider.of<CalculatorState>(
                        context,
                        listen: false,
                      );
                      calculatorState.setProductName(
                        item.calculatorField.id,
                        item.field.productName,
                      );
                    });

                    return CalculatorMasterListItem(
                      key: ValueKey(item.calculatorField),
                      field: item.field,
                      calculatorField: item.calculatorField,
                      onTap: () {},
                      index: index,
                    );
                  },
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Consumer<CalculatorState>(
                    builder: (context, state, _) {
                      return PrimaryButtonWithDiscount(
                        total: state.total,
                        onSave: (double finalTotal) {
                          showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                            backgroundColor: AppColor.surfaceColor,
                            builder: (context) {
                              return FractionallySizedBox(
                                heightFactor: 0.5,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: () async {
                                          final controller =
                                              Provider.of<
                                                CalculatorSessionController
                                              >(context, listen: false);

                                          final consumptionData = state
                                              .getConsumptionData();

                                          final session = CalculatorSession(
                                            id: "",
                                            userId: "1",
                                            clientId: "1",
                                            calculatorId: widget.calculator.id,
                                            createdAt: DateTime.now(),
                                            totalAmount:
                                                finalTotal, // делать - введеная сумма из кнопки
                                            consumptionData:
                                                consumptionData.isNotEmpty
                                                ? consumptionData
                                                : null,
                                            calculatorName:
                                                widget.calculator.name,
                                          );

                                          await controller.create(session);

                                          if (context.mounted) {
                                            Navigator.pop(context);
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: const Text(
                                                  "Сессия сохранена",
                                                ),
                                              ),
                                            );

                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const MainScreen(),
                                              ),
                                            );
                                          }
                                        },
                                        child: Center(
                                          child: const Text(
                                            'Сохранить',
                                            style: actionTextStyle,
                                          ),
                                        ),
                                      ),
                                    ),

                                    Expanded(
                                      child: InkWell(
                                        onTap: () async {
                                          final selectedClientId =
                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const SelectClient(),
                                                ),
                                              );
                                          if (selectedClientId != null) {
                                            final controller =
                                                Provider.of<
                                                  CalculatorSessionController
                                                >(context, listen: false);

                                            final consumptionData = state
                                                .getConsumptionData();

                                            final session = CalculatorSession(
                                              id: "",
                                              userId: "1",
                                              clientId: selectedClientId,
                                              calculatorId:
                                                  widget.calculator.id,
                                              createdAt: DateTime.now(),
                                              totalAmount: finalTotal,
                                              consumptionData:
                                                  consumptionData.isNotEmpty
                                                  ? consumptionData
                                                  : null,
                                              calculatorName:
                                                  widget.calculator.name,
                                            );

                                            await controller.create(session);

                                            if (context.mounted) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: const Text(
                                                    "Сессия сохранена",
                                                  ),
                                                ),
                                              );

                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const MainScreen(),
                                                ),
                                              );
                                            }
                                          }
                                        },
                                        child: Container(
                                          height: double.infinity,
                                          decoration: BoxDecoration(
                                            color: AppColor.primaryColor,
                                          ),
                                          child: Center(
                                            child: const Text(
                                              'Выбрать клиента',
                                              style: actionWhiteTextStyle,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
