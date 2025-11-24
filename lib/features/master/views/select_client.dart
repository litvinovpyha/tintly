import 'package:flutter/material.dart';
import 'package:tintly/shared/designs/dimens.dart';
import 'package:tintly/shared/widgets/custom_app_bar.dart';

class SelectClient extends StatelessWidget {
  const SelectClient({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Выбор Клиента'),
      body: Padding(
        padding: const EdgeInsetsGeometry.all(Dimens.padding16),
        // child: ClientsListPage(
        //   selectable: true,
        //   // добавляем callback при выборе клиента:
        //   onClientSelected: (clientId) {
        //     Navigator.pop(context, clientId);
        //   },
        // ),
      ),
    );
  }
}
