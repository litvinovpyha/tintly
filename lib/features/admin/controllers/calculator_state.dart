import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../services/calculator_logic_service.dart';

class CalculatorState extends ChangeNotifier {
  final CalculatorLogicService _logic = CalculatorLogicService();

  final Map<String, TextEditingController> _controllers = {};

  TextEditingController getController(String id) {
    if (!_controllers.containsKey(id)) {
      final controller = TextEditingController(
        text: _logic.getQuantity(id)?.toString() ?? '',
      );
      _controllers[id] = controller;
    }
    return _controllers[id]!;
  }

  void setQuantity(String calculatorFieldId, int quantity) {
    _logic.setQuantity(calculatorFieldId, quantity);
    notifyListeners();
  }

  // void setQuantity(String calculatorFieldId, int quantity) {
  //   _logic.setQuantity(calculatorFieldId, quantity);
  //   if (_controllers.containsKey(calculatorFieldId)) {
  //     _controllers[calculatorFieldId]!.text = quantity.toString();
  //   }
  //   notifyListeners();
  // }

  void setPrice(String calculatorFieldId, double price) {
    _logic.setPrice(calculatorFieldId, price);
    notifyListeners();
  }

  void setProductName(String calculatorFieldId, String productName) {
    _logic.setProductName(calculatorFieldId, productName);
    notifyListeners();
  }

  double getFieldTotal(String calculatorFieldId) =>
      _logic.getFieldTotal(calculatorFieldId);

  double get total => _logic.total;

  Map<String, double> getConsumptionData() => _logic.getConsumptionData();

  void reset() {
    _logic.clear();
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    _controllers.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    _controllers.clear();
    super.dispose();
  }
}
