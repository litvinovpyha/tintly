import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tintly/features/admin/controllers/calculator_session_controller.dart';
import 'package:tintly/features/admin/models/calculator.dart';
import 'package:tintly/features/admin/models/calculator_session.dart';
import 'package:tintly/shared/designs/app_color.dart';
import 'package:tintly/shared/designs/dimens.dart';
import 'package:tintly/shared/designs/icons.dart';
import 'package:tintly/shared/designs/styles.dart';
import 'package:tintly/shared/utils/currency_formatter.dart';
import 'package:tintly/shared/widgets/custom_list_tile.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  bool _localeReady = false;
  String _selectedPeriod = 'today';
  String type = 'Все';
  late Future<List<CalculatorSession>> _future;

  @override
  void initState() {
    super.initState();
    _initLocale();
  }

  Future<void> _initLocale() async {
    await initializeDateFormatting('ru_RU', null);
    final controller = Provider.of<CalculatorSessionController>(
      context,
      listen: false,
    );
    _future = controller.getToday(type);
    setState(() => _localeReady = true);
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void _updatePeriod(String period, String id) {
    final controller = Provider.of<CalculatorSessionController>(
      context,
      listen: false,
    );
    setState(() {
      _selectedPeriod = period;
      switch (period) {
        case 'today':
          _future = controller.getToday(id);
          break;
        case 'week':
          _future = controller.getConsumptionByPeriod('week', id);
          break;
        case 'month':
          _future = controller.getConsumptionByPeriod('month', id);
          break;
        case '3months':
          _future = controller.getConsumptionByPeriod('3months', id);

          break;
        case '6months':
          _future = controller.getConsumptionByPeriod('6months', id);
          break;
        case 'year':
          _future = controller.getConsumptionByPeriod('year', id);
          break;
        default:
          _future = controller.getConsumptionByPeriod('week', id);
      }
    });
  }

  void _updateType(Calculator item) {
    setState(() {
      type = item.name;
    });
    _updatePeriod(_selectedPeriod, item.id);
  }

  @override
  Widget build(BuildContext context) {
    if (!_localeReady) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child:  Text('Ошибка: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              if (_selectedPeriod != 'year') {
                final controller = Provider.of<CalculatorSessionController>(
                  context,
                  listen: false,
                );

                _future = controller.getConsumptionByPeriod('year', type);
                _selectedPeriod = 'year';
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {});
                });

                return const Center(child: CircularProgressIndicator());
              }
            }
            final sessions = snapshot.data!;
            final totalSum = sessions.fold<double>(
              0,
              (sum, session) => sum + (session.totalAmount),
            );

            return Expanded(
              child: Column(
                children: [
                  CustomListTile(
                    onTap: () async {
                      final result = await Navigator.pushNamed(
                        context,
                        '/period-select-screen',
                      );
                      if (result != null && mounted) {
                        _updatePeriod(result as String, 'Все');
                        final item = Calculator(
                          id: 'Все',
                          userId: 'Все',
                          name: 'Все',
                          placeholder: 'Все',
                          isActive: true,
                        );
                        _updateType(item);
                      }
                    },
                    leading: Icon(
                      Icons.calendar_today_outlined,
                      color: AppColor.primaryColor,
                    ),
                    title: _getPeriodTitle(_selectedPeriod),
                    subtitle: const Text(
                      'Выбрать период',
                      style: darkestTextStyle,
                    ),
                    trailing: chevronRight,
                  ),
                  CustomListTile(
                    leading: Icon(Icons.tune, color: AppColor.primaryColor),
                    title: type,
                    subtitle: const Text('Выбрать тип'),
                    trailing: chevronRight,
                    onTap: () async {
                      final item = await Navigator.pushNamed(
                        context,
                        '/history/selectTypes',
                      );
                      if (item != null && mounted) {
                        _updateType(item as Calculator);
                      }
                    },
                  ),
                  CustomListTile(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/products-info-screen',
                        arguments: sessions,
                      );
                    },
                    leading: Icon(
                      Icons.account_balance_wallet_outlined,
                      color: AppColor.primaryColor,
                    ),
                    trailing: chevronRight,
                    title: 'Операции',
                    subtitle:  Text(
                      CurrencyFormatter.format(totalSum),
                      style: greenTextStyle,
                    ),
                    divider: false,
                  ),

                  SizedBox(height: Dimens.height24),
                  Expanded(
                    child: ListView.builder(
                      itemCount: sessions.length,
                      itemBuilder: (context, index) {
                        final session = sessions[index];

                        final formattedDate = DateFormat(
                          'd MMMM',
                          'ru_RU',
                        ).format(session.createdAt);

                        bool showDateHeader = false;
                        if (index == 0) {
                          showDateHeader = true;
                        } else {
                          final prevSession = sessions[index - 1];
                          final isDifferentDay = !isSameDay(
                            session.createdAt,
                            prevSession.createdAt,
                          );
                          if (isDifferentDay) showDateHeader = true;
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (showDateHeader) ...[
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 16.0,
                                  bottom: 8.0,
                                  left: 16.0,
                                ),
                                child:  Text(
                                  formattedDate,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                            CustomListTile(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/history/feature-screen',
                                  arguments: session.id,
                                );
                              },
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
                                      ), // не работает нужно переназванить
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
                                child:  Text(
                                  DateFormat('HH:mm').format(session.createdAt),
                                  style: actionTextStyle,
                                ),
                              ),

                              title: session.calculatorName?.isNotEmpty == true
                                  ? session.calculatorName!
                                  : '',
                              subtitle:  Text(
                                CurrencyFormatter.format(session.totalAmount),
                                style: greenTextStyle,
                              ),
                              trailing: chevronRight,
                            ),
                            const SizedBox(height: 8),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  String _getPeriodTitle(String period) {
    switch (period) {
      case 'today':
        return 'Сегодня';
      case 'week':
        return 'За неделю';
      case 'month':
        return 'За месяц';
      case '3months':
        return 'За три месяца';
      case '6months':
        return 'За полгода';
      case 'year':
        return 'За год';
      default:
        return 'Сегодня';
    }
  }
}
