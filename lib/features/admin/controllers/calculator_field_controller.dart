import 'package:tintly/core/controllers/base_controller.dart';
import 'package:tintly/features/admin/models/calculator_field.dart';
import 'package:tintly/features/admin/services/calculator_field_service.dart';

class CalculatorFieldController extends BaseController<CalculatorField> {
  CalculatorFieldController(super.service);

  CalculatorFieldService get calculatorFieldService =>
      service as CalculatorFieldService;

  Future<void> updatePositions(
    String calculatorId,
    List<CalculatorField> calculatorFields,
  ) async {
    await calculatorFieldService.updatePositions(
      calculatorId,
      calculatorFields,
    );
    await loadItems();
  }
}
