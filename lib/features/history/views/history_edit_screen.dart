import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tintly/features/admin/controllers/calculator_session_controller.dart';
import 'package:tintly/shared/designs/dimens.dart';
import 'package:tintly/shared/designs/icons.dart';
import 'package:tintly/shared/widgets/choice_dialog.dart';
import 'package:tintly/shared/widgets/custom_app_bar.dart';
import 'package:tintly/shared/widgets/custom_list_tile.dart';

class HistoryEditScreen extends StatelessWidget {
  const HistoryEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'История'),
      body: Padding(
        padding: const EdgeInsetsGeometry.all(Dimens.padding16),
        child: Column(
          children: [
            CustomListTile(
              title: 'Очистить историю приложения',
              trailing: chevronRight,
              onTap: () async {
                bool? confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => ChoiceDialog(
                    title: 'Удалить',
                    description: 'Вы уверены? Вся история будет удалена.',
                    confirm: 'Удалить',
                  ),
                );

                if (confirm == true) {
                  final calculatorSessionController =
                      Provider.of<CalculatorSessionController>(
                        context,
                        listen: false,
                      );

                  await calculatorSessionController.deleteAllSessions();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
