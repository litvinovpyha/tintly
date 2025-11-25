import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tintly/app/edit_screen.dart';
import 'package:tintly/app/main_screen.dart';
import 'package:tintly/core/init/app_initializer.dart';
import 'package:tintly/core/init/providers_initializer.dart';
import 'package:tintly/core/di/service_locator.dart';
import 'package:tintly/features/admin/views/calculator_edit_screen.dart';
import 'package:tintly/features/courses/views/hairstylist/couse_hairstylist.dart';
import 'package:tintly/features/history/views/feature_history_screen.dart';
import 'package:tintly/features/onboarding/onboarding_screen.dart';
import 'package:tintly/features/products/views/unit_edit_screen.dart';
import 'package:tintly/features/history/views/history_edit_screen.dart';
import 'package:tintly/features/history/views/period_select_screen.dart';
import 'package:tintly/features/history/views/products_history_screen.dart';
import 'package:tintly/features/history/views/type/select_history_types.dart';
import 'package:tintly/features/products/views/brand_edit_screen.dart';
import 'package:tintly/shared/designs/app_color.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInitializer.init();
  //логин и онбординг
  runApp(TinTly());
}

class TinTly extends StatelessWidget {
  const TinTly({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: ProvidersInitializer.getProviders(ServiceLocator()),
      child: MaterialApp(
        title: 'TinTly',
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en'), Locale('ru')],
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColor.primaryColor,
            surfaceTint: Colors.transparent,
          ),
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
          ),
        ),
        home: MainScreen(),
        routes: <String, WidgetBuilder>{
          '/period-select-screen': (BuildContext context) =>
              const PeriodSelectScreen(),
          '/products-info-screen': (BuildContext context) =>
              const ProductsHistoryScreen(),
          '/settings/edit': (BuildContext context) => const EditScreen(),
          '/settings/edit/calculator': (BuildContext context) =>
              const CalculatorEditScreen(),
          '/settings/edit/history': (BuildContext context) =>
              const HistoryEditScreen(),
          '/settings/edit/unit': (BuildContext context) =>
              const UnitEditScreen(),
          '/settings/edit/brand': (BuildContext context) =>
              const BrandEditScreen(),
          '/history/selectTypes': (BuildContext context) =>
              const SelectHistoryTypes(),
          // '/history/feature-screen': (BuildContext context) =>
          //     const FeatureHistoryScreen(),
          '/courses/hairstylist': (BuildContext context) =>
              const CouseHairstylist(),
          '/onboarding': (BuildContext context) => const OnboardingScreen(),
        },
      ),
    );
  }
}
