import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tintly/features/calculatorSession/bloc/calculator_session_bloc.dart';
import 'package:tintly/features/calculatorSession/bloc/calculator_session_state.dart';
import 'package:tintly/shared/designs/dimens.dart';
import 'package:tintly/shared/designs/styles.dart';
import 'package:tintly/shared/widgets/custom_list_tile.dart';

class CalculatorSessionView extends StatelessWidget {
  const CalculatorSessionView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalculatorSessionBloc, CalculatorSessionState>(
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
        } else if (state is CalculatorSessionItemLoaded) {
          return Scaffold(
            appBar: AppBar(title: Text('Информация об услуге')),
            body: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  CustomListTile(
                    title: 'Создано:',
                    subtitle: Text(
                      style: darkestTextStyle,

                      DateFormat(
                        'd MMMM y, HH:mm',
                        'ru_RU',
                      ).format(state.calculatorSession.createdAt),
                    ),
                  ),

                  //TODO: если не указан добавить возможность указать
                  CustomListTile(
                    title: 'Клиент',
                    subtitle: Text(
                      state.calculatorSession.clientId == ''
                          ? 'Не указан'
                          : state.calculatorSession.clientId,
                      style: darkestTextStyle,
                    ),
                  ),
                  CustomListTile(
                    title: 'Итоговая Сумма:',
                    subtitle: Text(
                      '${state.calculatorSession.totalAmount.toStringAsFixed(0)} тнг.',
                      style: darkestTextStyle,
                    ),
                  ),

                  SizedBox(height: Dimens.height24),
                  CustomListTile(
                    title: 'Затраченные Материалы:',
                    divider: false,
                  ),

                  Expanded(
                    child: ListView.builder(
                      itemCount:
                          state.calculatorSession.consumptionData?.length ?? 0,
                      itemBuilder: (context, index) {
                        final key = state
                            .calculatorSession
                            .consumptionData!
                            .keys
                            .elementAt(index);
                        final value = state
                            .calculatorSession
                            .consumptionData!
                            .values
                            .elementAt(index);

                        return CustomListTile(
                          trailing: Text(
                            "${value.toStringAsFixed(0)} ед.",
                            style: headingH5TextStyle,
                          ),
                          title: key,
                          subtitle: const Text("", style: darkestTextStyle),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return const Center(child: Text('Инициализация...'));
      },
    );
  }
}
