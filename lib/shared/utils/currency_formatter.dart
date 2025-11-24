import 'package:intl/intl.dart';

class CurrencyFormatter {
  static String format(
    num amount, {
    String locale = 'kk_KZ',
    String? currencySymbol,
  }) {
    final symbol = currencySymbol ?? getCurrencySymbol(locale);

    final formatter = NumberFormat.currency(
      locale: locale,
      symbol: symbol,
      decimalDigits: 0,
    );

    return formatter.format(amount);
  }

  static String getCurrencySymbol(String locale) {
    switch (locale) {
      case 'kk_KZ':
      case 'ru_KZ':
        return '₸';
      case 'ru_RU':
        return '₽';
      case 'en_US':
        return '\$';
      case 'en_GB':
        return '£';
      case 'eu_EU':
        return '€';
      default:
        return '';
    }
  }
}
