import 'package:flutter/cupertino.dart';
import 'package:tintly/shared/designs/icons.dart';
import 'package:tintly/shared/enums/history_period.dart';
import 'package:tintly/shared/widgets/custom_list_tile.dart';

class HistoryPeriodScreen extends StatelessWidget {
  const HistoryPeriodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text('Выбрать период')),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomListTile(
              title: 'Сегодня',
              trailing: chevronRight,
              onTap: () => Navigator.pop(context, HistoryPeriod.today),
            ),
            CustomListTile(
              title: 'Последние 7 дней',
              trailing: chevronRight,
              onTap: () => Navigator.pop(
                context,
                HistoryPeriod.week,
              ), //today  week month
            ),
            CustomListTile(
              title: 'Последние 30 дней',
              trailing: chevronRight,
              onTap: () => Navigator.pop(context, HistoryPeriod.month),
            ),
            CustomListTile(
              title: 'Пол года',
              trailing: chevronRight,
              onTap: () => Navigator.pop(context, HistoryPeriod.halfYear),
            ),
            CustomListTile(
              title: 'За год',
              trailing: chevronRight,
              onTap: () => Navigator.pop(context, HistoryPeriod.year),
            ),
          ],
        ),
      ),
    );
  }
}
