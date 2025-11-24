import 'package:flutter/material.dart';
import 'package:tintly/shared/designs/dimens.dart';
import 'package:tintly/shared/designs/icons.dart';
import 'package:tintly/shared/widgets/custom_app_bar.dart';
import 'package:tintly/shared/widgets/custom_list_tile.dart';

class PeriodSelectScreen extends StatelessWidget {
  const PeriodSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Фильтр'),
      body: Padding(
        padding: const EdgeInsetsGeometry.all(Dimens.padding16),
        child: Column(
          children: [
            CustomListTile(
              onTap: () {
                Navigator.pop(context, 'today');
              },
              trailing: chevronRight,

              title: 'За Сегодня',
            ),
            CustomListTile(
              onTap: () {
                Navigator.pop(context, 'week');
              },
              trailing: chevronRight,

              title: 'За неделю',
            ),
            CustomListTile(
              onTap: () {
                Navigator.pop(context, 'month');
              },

              title: 'За месяц',

              trailing: chevronRight,
            ),
            CustomListTile(
              onTap: () {
                Navigator.pop(context, '3months');
              },

              title: 'За три месяца',

              trailing: chevronRight,
            ),
            CustomListTile(
              onTap: () {
                Navigator.pop(context, '6months');
              },

              title: 'За полгода',

              trailing: chevronRight,
            ),
            CustomListTile(
              onTap: () {
                Navigator.pop(context, 'year');
              },
              trailing: chevronRight,

              title: 'За год',
            ),
          ],
        ),
      ),
    );
  }
}
