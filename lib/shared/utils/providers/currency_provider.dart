// import 'package:flutter/material.dart';

// class CurrencyProvider extends ChangeNotifier {
//   String _locale = 'kk_KZ';
//   String _symbol = '₸';

//   String get locale => _locale;
//   String get symbol => _symbol;

//   void setCurrency(String locale) {
//     _locale = locale;

//     switch (locale) {
//       case 'kk_KZ':
//       case 'ru_KZ':
//         _symbol = '₸';
//         break;
//       case 'ru_RU':
//         _symbol = '₽';
//         break;
//       case 'en_US':
//         _symbol = '\$';
//         break;
//       case 'en_GB':
//         _symbol = '£';
//         break;
//       case 'eu_EU':
//         _symbol = '€';
//         break;
//       default:
//         _symbol = '';
//     }

//     notifyListeners();
//   }
// }
