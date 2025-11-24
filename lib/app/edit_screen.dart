import 'package:flutter/material.dart';
import 'package:tintly/shared/designs/dimens.dart';
import 'package:tintly/shared/designs/icons.dart';
import 'package:tintly/shared/widgets/custom_app_bar.dart';
import 'package:tintly/shared/widgets/custom_list_tile.dart';

class EditScreen extends StatelessWidget {
  const EditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Редактирование'),
      body: Padding(
        padding: const EdgeInsetsGeometry.all(Dimens.padding16),

        child: Column(
          children: [
            CustomListTile(
              title: 'Настройка калькулятора',
              trailing: chevronRight,
              onTap: () async {
                Navigator.pushNamed(context, '/settings/edit/calculator');
              },
            ),
            CustomListTile(
              title: 'Настройка истории',
              trailing: chevronRight,
              onTap: () async {
                Navigator.pushNamed(context, '/settings/edit/history');
              },
            ),

            CustomListTile(
              title: 'Настройка брендов',
              trailing: chevronRight,
              onTap: () async {
                Navigator.pushNamed(context, '/settings/edit/brand');
              },
            ),
            CustomListTile(
              title: 'Настройка Единиц измерения',
              trailing: chevronRight,
              onTap: () async {
                Navigator.pushNamed(context, '/settings/edit/unit');
              },
            ),
            CustomListTile(
              title: 'Показать Знакомство с приложением',
              trailing: chevronRight,
              onTap: () async {
                Navigator.pushNamed(context, '/onboarding');
              },
            ),
            CustomListTile(
              title: 'Показать обучение с приложением',
              trailing: chevronRight,
              onTap: () => _restartOnboarding(context),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _restartOnboarding(BuildContext context) async {
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.setBool('seen_intro', false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Обучение будет показано при следующем запуске приложения',
        ),
        duration: Duration(seconds: 3),
      ),
    );
  }
}
