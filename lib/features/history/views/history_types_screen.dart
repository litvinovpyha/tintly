import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tintly/features/calculatorSession/bloc/calculator_session_bloc.dart';
import 'package:tintly/features/calculatorSession/bloc/calculator_session_state.dart';
import 'package:tintly/shared/designs/icons.dart';
import 'package:tintly/shared/widgets/custom_list_tile.dart';

class HistoryTypesScreen extends StatelessWidget {
  const HistoryTypesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text('Выбор типа')),
      child: BlocBuilder<CalculatorSessionBloc, CalculatorSessionState>(
        builder: (context, state) {
          if (state is CalculatorSessionLoading) {
            return const Center(
              child: CupertinoActivityIndicator(
                radius: 20.0,
                color: CupertinoColors.activeBlue,
              ),
            );
          } else if (state is CalculatorSessionError) {
            return Center(child: Text('Ошибка: ${state.message}'));
          } else if (state is CalculatorSessionLoaded) {
            if (state.calculatorSession.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Нет доступных единиц.'),
                    Text('Создайте новое: Например: "Краситель"'),
                  ],
                ),
              );
            }
            final uniqueNames = state.calculatorSession
                .where((e) => e.calculatorName != null)
                .map((e) => e.calculatorName!)
                .toSet()
                .toList();

            return ListView.builder(
              itemCount: uniqueNames.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return CustomListTile(
                    title: 'Все типы',
                    trailing: chevronRight,
                    onTap: () {
                      Navigator.pop(context, 'all');
                    },
                  );
                }
                final name = uniqueNames[index - 1];

                return CustomListTile(
                  title: name,
                  trailing: chevronRight,
                  onTap: () {
                    Navigator.pop(context, name);
                  },
                );
              },
            );
          }

          return const Center(child: Text('Неизвестное состояние.'));
        },
      ),
    );
  }
}
