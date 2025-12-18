import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tintly/features/calculatorSession/bloc/calculator_session_bloc.dart';
import 'package:tintly/features/calculatorSession/bloc/calculator_session_event.dart';
import 'package:tintly/features/calculatorSession/bloc/calculator_session_state.dart';
import 'package:tintly/features/calculatorSession/models/calculator_session.dart';
import 'package:tintly/features/history/views/history_period_screen.dart';
import 'package:tintly/features/history/views/history_types_screen.dart';
import 'package:tintly/shared/designs/app_color.dart';
import 'package:tintly/shared/designs/dimens.dart';
import 'package:tintly/shared/designs/icons.dart';
import 'package:tintly/shared/designs/styles.dart';
import 'package:tintly/shared/enums/history_period.dart';
import 'package:tintly/shared/widgets/custom_list_tile.dart';

class HistoryList extends StatefulWidget {
  const HistoryList({super.key});

  @override
  State<HistoryList> createState() => _HistoryListState();
}

class _HistoryListState extends State<HistoryList> {
  HistoryPeriod period = HistoryPeriod.week;
  String defaultType = 'Все типы';
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
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<CalculatorSessionBloc>().add(
                LoadSessionsByPeriod(period.next),
              );
            });

            return const Center(child: Text('Нет доступной истории.'));
          }

          final totalSum = state.calculatorSession.fold<double>(
            0,
            (sum, session) => sum + (session.totalAmount),
          );
          final groupedSessions = groupByDate(state.calculatorSession);
          final dates = groupedSessions.keys.toList();

          return Column(
            children: [
              CustomListTile(
                onTap: () async {
                  final HistoryPeriod? period =
                      await Navigator.push<HistoryPeriod>(
                        context,
                        CupertinoPageRoute(
                          builder: (_) => const HistoryPeriodScreen(),
                        ),
                      );

                  if (period != null && context.mounted) {
                    context.read<CalculatorSessionBloc>().add(
                      LoadSessionsByPeriod(period),
                    );
                    setState(() {
                      this.period = period;
                    });
                  }
                },
                leading: Icon(
                  Icons.calendar_today_outlined,
                  color: AppColor.primaryColor,
                ),
                title: period.title,
                subtitle: const Text('Выбрать', style: darkestTextStyle),
                trailing: chevronRight,
              ),

              CustomListTile(
                onTap: () async {
                  final String? type = await Navigator.push<String>(
                    context,
                    CupertinoPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<CalculatorSessionBloc>(),
                        child: const HistoryTypesScreen(),
                      ),
                    ),
                  );

                  if (!context.mounted || type == null) return;

                  if (type == 'all') {
                    context.read<CalculatorSessionBloc>().add(
                      LoadSessionsByPeriod(period),
                    );
                    setState(() {
                      defaultType = "Все типы";
                    });
                  } else {
                    context.read<CalculatorSessionBloc>().add(
                      LoadSessionsByType(type),
                    );
                    setState(() {
                      defaultType = type;
                    });
                  }
                },
                leading: Icon(Icons.tune, color: AppColor.primaryColor),
                title: defaultType,
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
                subtitle: Text(
                  totalSum.toStringAsFixed(0),
                  style: darkestTextStyle,
                ),
                divider: false,
              ),
              SizedBox(height: Dimens.height24),

              Expanded(
                child: ListView.builder(
                  itemCount: groupedSessions.length,
                  itemBuilder: (context, index) {
                    final date = dates[index];
                    final sessions = groupedSessions[date]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Text(
                            date,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        ...sessions.map(
                          (session) => CustomListTile(
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
                                    color: AppColor.greyColor.withValues(
                                      alpha: 0.25,
                                    ),
                                    blurRadius: 3,
                                    offset: const Offset(1, 1),
                                  ),
                                ],
                                border: Border.all(
                                  color: AppColor.blackColor.withValues(
                                    alpha: 0.2,
                                  ),
                                  width: 0.5,
                                ),
                              ),
                              child: Text(
                                DateFormat('HH:mm').format(session.createdAt),
                                style: actionTextStyle,
                              ),
                            ),
                            subtitle: Text(
                              session.totalAmount.toStringAsFixed(0),
                              style: greenTextStyle,
                            ),
                            trailing: chevronRight,
                          ),
                        ),
                      ],
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

Map<String, List<CalculatorSession>> groupByDate(
  List<CalculatorSession> sessions,
) {
  final Map<String, List<CalculatorSession>> grouped = {};

  for (var session in sessions) {
    final dateKey = DateFormat('dd MMMM', 'ru_RU').format(session.createdAt);
    if (!grouped.containsKey(dateKey)) {
      grouped[dateKey] = [];
    }
    grouped[dateKey]!.add(session);
  }

  return grouped;
}
