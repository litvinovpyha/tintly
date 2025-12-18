enum HistoryPeriod { today, week, month, halfYear, year }

extension HistoryPeriodX on HistoryPeriod {
  String get title {
    switch (this) {
      case HistoryPeriod.today:
        return 'Сегодня';
      case HistoryPeriod.week:
        return 'Последние 7 дней';
      case HistoryPeriod.month:
        return 'Последние 30 дней';
      case HistoryPeriod.halfYear:
        return 'Пол года';
      case HistoryPeriod.year:
        return 'За год';
    }
  }

  HistoryPeriod get next {
    switch (this) {
      case HistoryPeriod.today:
        return HistoryPeriod.week;
      case HistoryPeriod.week:
        return HistoryPeriod.month;
      case HistoryPeriod.month:
        return HistoryPeriod.halfYear;
      case HistoryPeriod.halfYear:
        return HistoryPeriod.year;
      case HistoryPeriod.year:
        return HistoryPeriod.year; 
    }
  }
}
