import 'package:flutter/material.dart';
import 'package:tintly/core/routes/app_routes.dart';
import 'package:tintly/shared/designs/dimens.dart';
import 'package:tintly/shared/designs/icons.dart';
import 'package:tintly/shared/widgets/custom_list_tile.dart';

class EditScreen extends StatelessWidget {
  const EditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Редактирование')),
      body: Padding(
        padding: const EdgeInsetsGeometry.all(Dimens.padding16),
        child: Column(
          children: [
            CustomListTile(
              title: 'Настройка калькулятора',
              trailing: chevronRight,
              onTap: () async {
                Navigator.pushNamed(context, RouteNames.editCalculator);
              },
            ),
            CustomListTile(
              title: 'Настройка истории',
              trailing: chevronRight,
              onTap: () async {
                Navigator.pushNamed(context, RouteNames.editHistory);
              },
            ),

            CustomListTile(
              title: 'Настройка брендов',
              trailing: chevronRight,
              onTap: () async {
                Navigator.pushNamed(context, RouteNames.editBrand);
              },
            ),
            CustomListTile(
              title: 'Настройка Единиц измерения',
              trailing: chevronRight,
              onTap: () async {
                Navigator.pushNamed(context, RouteNames.editUnit);
              },
            ),
            CustomListTile(
              title: 'Показать Знакомство с приложением',
              trailing: chevronRight,
              onTap: () async {
                Navigator.pushNamed(context, RouteNames.onboarding);
              },
            ),
          ],
        ),
      ),
    );
  }
}
