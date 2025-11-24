import 'package:tintly/core/controllers/base_controller.dart';
import 'package:tintly/features/admin/models/calculator.dart';
import 'package:tintly/features/admin/services/calculator_service.dart';

class CalculatorController extends BaseController<Calculator> {
  CalculatorController(super.service);

  CalculatorService get calculatorService => service as CalculatorService;
}
