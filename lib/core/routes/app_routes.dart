import 'package:flutter/widgets.dart';
import 'package:tintly/app/edit_screen.dart';
import 'package:tintly/app/main_screen.dart';
import 'package:tintly/features/brand/views/brand_edit_screen.dart';
import 'package:tintly/features/calculating/views/edit_calculating_screen.dart';
import 'package:tintly/features/calculator/views/calculator_edit_screen.dart';
import 'package:tintly/features/calculatorSession/views/calculator_session_screen.dart';
import 'package:tintly/features/client/views/profile_screen.dart';
import 'package:tintly/features/courses/views/hairstylist/couse_hairstylist.dart';
import 'package:tintly/features/field/models/field.dart';
import 'package:tintly/features/field/views/field_screen.dart';
import 'package:tintly/features/field/views/field_create_screen.dart';
import 'package:tintly/features/history/views/history_edit_screen.dart';
import 'package:tintly/features/calculating/views/calculating_screen.dart';
import 'package:tintly/features/onboarding/onboarding_screen.dart';
import 'package:tintly/features/price/views/price_Screen.dart';
import 'package:tintly/features/price/views/price_create.dart';
import 'package:tintly/features/unit/views/unit_edit_screen.dart';

class RouteNames {
  
  //MAIN
  static const main = '/main';
  
  //ROOT
  static const settinngsEdit = '/settings/edit';
  static const onboarding = '/onboarding';
  
  //HOME
  static const hairCousesList = '/home/courses/hairstylist';
  
  //CLIENT
  static const clientProfile = '/client/profile';
  
  //CALCULATING
  static const calculating = '/home/calculating';
  static const editCalculating = '/settings/edit/calculator/edit';

  //SETTINGS
  static const editCalculator = '/settings/edit/calculator';
  static const editHistory = '/settings/edit/history';
  static const editUnit = '/settings/edit/unit';
  static const editBrand = '/settings/edit/brand';
  
  //HISTORY
  static const historySession = '/history/calculatorSession';
  
  //FIELD
  static const field = '/field';
  static const fieldCreate = '/field/create';
  
  //PRICE
  static const price = '/price';
  static const priceCreate = '/price/create';
}

class AppRoutes {
  static Map<String, WidgetBuilder> get routes {
    return {
      //MAIN
      RouteNames.main: (BuildContext context) => const MainScreen(),
      //ROOT
      RouteNames.settinngsEdit: (BuildContext context) => const EditScreen(),
      RouteNames.onboarding: (BuildContext context) => const OnboardingScreen(),

      //HOME
      RouteNames.hairCousesList: (BuildContext context) =>
          const CouseHairstylist(),

      //CLIENT
      RouteNames.clientProfile: (BuildContext context) => const ProfileScreen(),

      //CALCULATING
      RouteNames.calculating: (BuildContext context) =>
          const CalculatingScreen(),

      RouteNames.editCalculating: (BuildContext context) {
        final calculatorId =
            ModalRoute.of(context)!.settings.arguments as String;
        return EditCalculatingScreen(calculatorId: calculatorId);
      },

      //SETTINGS
      RouteNames.editCalculator: (BuildContext context) =>
          const CalculatorEditScreen(),
      RouteNames.editHistory: (BuildContext context) =>
          const HistoryEditScreen(),
      RouteNames.editUnit: (BuildContext context) => const UnitEditScreen(),
      RouteNames.editBrand: (BuildContext context) => const BrandEditScreen(),

      //HISTORY
      RouteNames.historySession: (BuildContext context) =>
          const CalculatorSessionScreen(),
      //FIELD
      '/field': (context) {
        final calculatorId =
            ModalRoute.of(context)!.settings.arguments as String;

        return FieldScreen(calculatorId: calculatorId);
      },
      RouteNames.fieldCreate: (BuildContext context) =>
          const FieldCreateScreen(),

      //PRICE
      RouteNames.price: (BuildContext context) {
        final field = ModalRoute.of(context)!.settings.arguments as Field;

        return PriceScreen(field: field);
      },
      RouteNames.priceCreate: (BuildContext context) {
        final Field field = ModalRoute.of(context)!.settings.arguments  as Field;
        return PriceCreate(field: field);
      },
    };
  }
}
