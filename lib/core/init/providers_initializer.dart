import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tintly/core/di/service_locator.dart';
import 'package:tintly/core/logger/app_logger.dart';
import 'package:tintly/features/admin/controllers/calculator_state.dart';
import 'package:tintly/features/products/controllers/unit_controller.dart';
import 'package:tintly/features/admin/controllers/field_controller.dart';
import 'package:tintly/features/products/controllers/brand_controller.dart';
import 'package:tintly/features/products/controllers/price_controller.dart';
import 'package:tintly/features/admin/controllers/calculator_controller.dart';
import 'package:tintly/features/admin/controllers/calculator_field_controller.dart';
import 'package:tintly/features/admin/controllers/calculator_session_controller.dart';
import 'package:tintly/features/history/controllers/consumption_controller.dart';
import 'package:tintly/features/products/services/unit_service.dart';
import 'package:tintly/features/admin/services/field_service.dart';
import 'package:tintly/features/products/services/brand_service.dart';
import 'package:tintly/features/products/services/price_service.dart';
import 'package:tintly/features/admin/services/calculator_service.dart';
import 'package:tintly/features/admin/services/calculator_field_service.dart';
import 'package:tintly/features/admin/services/calculator_session_service.dart';
import 'package:tintly/features/history/services/consumption_service.dart';

class _ProviderConfig<C extends ChangeNotifier, S> {
  final C Function(S service) factory;

  const _ProviderConfig(this.factory);

  ChangeNotifierProvider<C> create(ServiceLocator sl) {
    return ChangeNotifierProvider<C>(create: (_) => factory(sl.get<S>()));
  }
}

class ProvidersInitializer {
  static List<ChangeNotifierProvider> getProviders(ServiceLocator sl) {
    AppLogger.info('Creating providers...');

    try {
      final providerConfigs = [
        _ProviderConfig<UnitController, UnitService>(
          (service) => UnitController(service),
        ),
        _ProviderConfig<FieldController, FieldService>(
          (service) => FieldController(service),
        ),
        _ProviderConfig<BrandController, BrandService>(
          (service) => BrandController(service),
        ),
        _ProviderConfig<PriceController, PriceService>(
          (service) => PriceController(service),
        ),
        _ProviderConfig<CalculatorController, CalculatorService>(
          (service) => CalculatorController(service),
        ),
        _ProviderConfig<CalculatorFieldController, CalculatorFieldService>(
          (service) => CalculatorFieldController(service),
        ),
        _ProviderConfig<CalculatorSessionController, CalculatorSessionService>(
          (service) => CalculatorSessionController(service),
        ),
        _ProviderConfig<ConsumptionController, ConsumptionService>(
          (service) => ConsumptionController(service),
        ),
      ];

      final providers = providerConfigs
          .map((config) => config.create(sl))
          .toList();
      providers.add(
        ChangeNotifierProvider<CalculatorState>(
          create: (_) => CalculatorState(),
        ),
      );
      AppLogger.info('All ${providers.length} providers created successfully');
      return providers;
    } catch (e) {
      AppLogger.error('Error creating providers', 'ProvidersInitializer', e);
      rethrow;
    }
  }
}
