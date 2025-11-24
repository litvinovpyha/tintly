import 'package:hive_flutter/hive_flutter.dart';
import 'package:tintly/features/products/models/brand.dart';
import 'package:tintly/features/admin/models/calculator.dart';
import 'package:tintly/features/admin/models/calculator_field.dart';
import 'package:tintly/features/admin/models/calculator_session.dart';
import 'package:tintly/features/client/models/client.dart';
import 'package:tintly/features/admin/models/field.dart';
import 'package:tintly/features/products/models/price.dart';
import 'package:tintly/features/products/models/unit.dart';
import 'package:tintly/features/user/models/user.dart';
import 'package:tintly/features/history/models/consumption.dart';
import 'package:tintly/seeder/brand_seeder.dart';

class HiveInitializer {
  static Future<void> init() async {
    await Hive.initFlutter();

    // Регистрируем адаптеры
    Hive.registerAdapter(BrandAdapter());
    Hive.registerAdapter(CalculatorAdapter());
    Hive.registerAdapter(CalculatorFieldAdapter());
    Hive.registerAdapter(CalculatorSessionAdapter());
    Hive.registerAdapter(ClientAdapter());
    Hive.registerAdapter(FieldAdapter());
    Hive.registerAdapter(PriceAdapter());
    Hive.registerAdapter(UnitAdapter());
    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(ConsumptionAdapter());

    // Открываем боксы
    await Hive.openBox<Brand>('brands');
    await Hive.openBox<Calculator>('calculators');
    await Hive.openBox<CalculatorField>('calculatorFields');
    await Hive.openBox<CalculatorSession>('calculatorSessions');
    await Hive.openBox<Client>('clients');
    await Hive.openBox<Field>('fields');
    await Hive.openBox<Price>('prices');
    await Hive.openBox<Unit>('units');
    await Hive.openBox<User>('users');
    await Hive.openBox<Consumption>('consumptions');

    // Запускаем сидеры
    await brandSeeder();
  }
}
