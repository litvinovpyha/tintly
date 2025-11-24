import 'package:tintly/core/di/service_locator.dart';
import 'package:tintly/core/base_repository.dart';
import 'package:tintly/features/products/services/unit_service.dart';
import 'package:tintly/features/admin/services/field_service.dart';
import 'package:tintly/features/products/services/brand_service.dart';
import 'package:tintly/features/products/services/price_service.dart';
import 'package:tintly/features/admin/services/calculator_service.dart';
import 'package:tintly/features/admin/services/calculator_field_service.dart';
import 'package:tintly/features/admin/services/calculator_session_service.dart';
import 'package:tintly/features/history/services/consumption_service.dart';
import 'package:tintly/features/products/models/unit.dart';
import 'package:tintly/features/admin/models/field.dart';
import 'package:tintly/features/products/models/brand.dart';
import 'package:tintly/features/products/models/price.dart';
import 'package:tintly/features/admin/models/calculator.dart';
import 'package:tintly/features/admin/models/calculator_field.dart';
import 'package:tintly/features/admin/models/calculator_session.dart';
import 'package:tintly/features/history/models/consumption.dart';

class ServiceLocatorInitializer {
  static void init() {
    final sl = ServiceLocator();
    print('ServiceLocator initialized');


    sl.register<UnitService>(UnitService(GenericRepository<Unit>('units')));
    sl.register<FieldService>(FieldService(GenericRepository<Field>('fields')));
    sl.register<BrandService>(BrandService(GenericRepository<Brand>('brands')));
    sl.register<PriceService>(PriceService(GenericRepository<Price>('prices')));
    sl.register<CalculatorService>(
      CalculatorService(GenericRepository<Calculator>('calculators')),
    );
    sl.register<CalculatorFieldService>(
      CalculatorFieldService(
        GenericRepository<CalculatorField>('calculatorFields'),
      ),
    );
    sl.register<CalculatorSessionService>(
      CalculatorSessionService(
        GenericRepository<CalculatorSession>('calculatorSessions'),
      ),
    );
    sl.register<ConsumptionService>(
      ConsumptionService(GenericRepository<Consumption>('consumptions')),
    );
    print('All services registered successfully');
  }
}
