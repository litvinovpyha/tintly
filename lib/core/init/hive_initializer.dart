import 'package:hive_flutter/hive_flutter.dart';
import 'package:tintly/core/auth/repository/auth_repository.dart';
import 'package:tintly/features/brand/models/brand.dart';
import 'package:tintly/features/calculator/models/calculator.dart';
import 'package:tintly/features/calculatorField/models/calculator_field.dart';
import 'package:tintly/features/calculatorSession/models/calculator_session.dart';
import 'package:tintly/features/client/models/client.dart';
import 'package:tintly/features/field/models/field.dart';
import 'package:tintly/features/price/models/price.dart';
import 'package:tintly/features/unit/models/unit.dart';
import 'package:tintly/features/user/models/user.dart';
import 'package:tintly/features/history/models/consumption.dart';
import 'package:tintly/seeder/brand_seeder.dart';

class HiveInitializer {
  static Future<AuthRepository> init() async {
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

    await Hive.openBox<Brand>('brand');
    await Hive.openBox<Calculator>('calculator');
    await Hive.openBox<CalculatorField>('calculatorField');
    await Hive.openBox<CalculatorSession>('calculatorSession');
    await Hive.openBox<Client>('client');
    await Hive.openBox<Field>('field');
    await Hive.openBox<Price>('price');
    await Hive.openBox<Unit>('unit');
    await Hive.openBox<User>('user');
    await Hive.openBox<Consumption>('consumption');
    final Box<User> authBox = await Hive.openBox<User>('authBox');
    final authRepository = AuthRepository(authBox);
    await brandSeeder();

    await _migrateAndOpenBox<Brand>(oldName: 'brands', newName: 'brand');
    await _migrateAndOpenBox<Calculator>(
      oldName: 'calculators',
      newName: 'calculator',
    );
    await _migrateAndOpenBox<CalculatorField>(
      oldName: 'calculatorFields',
      newName: 'calculatorField',
    );
    await _migrateAndOpenBox<CalculatorSession>(
      oldName: 'calculatorSessions',
      newName: 'calculatorSession',
    );
    await _migrateAndOpenBox<Client>(oldName: 'clients', newName: 'client');
    await _migrateAndOpenBox<Field>(oldName: 'fields', newName: 'field');
    await _migrateAndOpenBox<Price>(oldName: 'prices', newName: 'price');
    await _migrateAndOpenBox<Unit>(oldName: 'units', newName: 'unit');
    await _migrateAndOpenBox<User>(oldName: 'users', newName: 'user');
    await _migrateAndOpenBox<Consumption>(
      oldName: 'consumptions',
      newName: 'consumption',
    );
    return authRepository;
  }

  static Future<void> _migrateAndOpenBox<T>({
    required String oldName,
    required String newName,
  }) async {
    if (await Hive.boxExists(oldName)) {
      final oldBox = await Hive.openBox<T>(oldName);

      if (oldBox.isNotEmpty) {
        final newBox = await Hive.openBox<T>(newName);

        for (var key in oldBox.keys) {
          final value = oldBox.get(key);
          if (value != null) {
            await newBox.put(key, value);
          }
        }
      }

      await oldBox.close();
      await Hive.deleteBoxFromDisk(oldName);
      print(
        'Hive Migration: Successfully migrated data from $oldName to $newName.',
      );
    }

    if (!Hive.isBoxOpen(newName)) {
      await Hive.openBox<T>(newName);
    }
  }
}
