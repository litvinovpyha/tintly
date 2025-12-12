import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tintly/features/calculatorSession/bloc/calculator_session_bloc.dart';
import 'package:tintly/features/calculatorSession/bloc/calculator_session_state.dart';
import 'package:tintly/shared/designs/app_color.dart';
import 'package:tintly/shared/designs/dimens.dart';
import 'package:tintly/shared/designs/icons.dart';
import 'package:tintly/shared/designs/styles.dart';
import 'package:tintly/shared/widgets/custom_list_tile.dart';

class HistoryList extends StatelessWidget {
  const HistoryList({super.key});

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
        } else if (state is CalculatorSessionLoaded) {
          if (state.calculatorSession.isEmpty) {
            return const Center(child: Text('Нет доступной истории.'));
          }
          final totalSum = state.calculatorSession.fold<double>(
            0,
            (sum, session) => sum + (session.totalAmount),
          );
          return Column(
            children: [
              CustomListTile(
                onTap: () {
                  Navigator.pushNamed(context, '');
                },
                leading: Icon(
                  Icons.calendar_today_outlined,
                  color: AppColor.primaryColor,
                ),
                title: 'За месяц',
                subtitle: const Text('Выбрать', style: darkestTextStyle),
                trailing: chevronRight,
              ),
              CustomListTile(
                leading: Icon(Icons.tune, color: AppColor.primaryColor),
                title: "Все",
                subtitle: const Text('Выбрать', style: darkestTextStyle),
                trailing: chevronRight,
              ),
              CustomListTile(
                leading: Icon(
                  Icons.account_balance_wallet_outlined,
                  color: AppColor.primaryColor,
                ),
                trailing: chevronRight,
                title: 'Операции',
                subtitle: Text(totalSum.toString(), style: darkestTextStyle),
                divider: false,
              ),
              SizedBox(height: Dimens.height24),
              Expanded(
                child: ListView.builder(
                  itemCount: state.calculatorSession.length,
                  itemBuilder: (context, index) {
                    final session = state.calculatorSession[index];

                    return CustomListTile(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/history/calculatorSession',
                          arguments: session.id,
                        );
                      },
                      title: session.calculatorName.toString(),
                      leading: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F0FA),
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                              color: AppColor.greyColor.withValues(alpha: 0.25),
                              blurRadius: 3,
                              offset: const Offset(1, 1),
                            ),
                          ],
                          border: Border.all(
                            color: AppColor.blackColor.withValues(alpha: 0.2),
                            width: 0.5,
                          ),
                        ),
                        child: Text(
                          DateFormat('HH:mm').format(session.createdAt),
                          style: actionTextStyle,
                        ),
                      ),
                      subtitle: Text(
                        session.totalAmount.toString(),
                        style: greenTextStyle,
                      ),
                      trailing: chevronRight,
                    );
                  },
                ),
              ),
            ],
          );
        }
        return const Center(child: Text('Инициализация...'));
      },
    );
  }
}
