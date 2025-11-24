import 'package:flutter/material.dart';
import 'package:tintly/features/history/models/consumption.dart';
import 'package:tintly/features/history/services/consumption_service.dart';

class ConsumptionController extends ChangeNotifier {
  final ConsumptionService consumptionService;
  List<Consumption> consumptions = [];
  bool isLoading = false;

  ConsumptionController(this.consumptionService);

  Future<void> loadConsumptions() async {
    if (isLoading) return;

    isLoading = true;
    notifyListeners();

    try {
      final result = await consumptionService.getAll();
      if (result.isFailure) {
        throw Exception(result.error);
      }
      consumptions = result.data!;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> create(Consumption consumption) async {
    await consumptionService.create(consumption);
    await loadConsumptions();
  }

  Future<void> delete(String id) async {
    await consumptionService.delete(id);
    await loadConsumptions();
  }
}
