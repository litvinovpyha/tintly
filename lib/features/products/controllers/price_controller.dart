import 'package:flutter/material.dart';
import 'package:tintly/features/products/models/price.dart';
import 'package:tintly/features/products/services/price_service.dart';

class PriceController extends ChangeNotifier {
  final PriceService priceService;
  List<Price> prices = [];
  bool isLoading = false;

  PriceController(this.priceService);

  Future<void> loadPrices() async {
    if (isLoading) return;

    isLoading = true;
    notifyListeners();

    try {
      final result = await priceService.getAll();
      if (result.isFailure) {
        throw Exception(result.error);
      }
      prices = result.data!;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> create(Price i) async {
    await priceService.create(i);
    await loadPrices();
  }

  Future<List<Price>> getByField(String fieldId) async {
    final result = await priceService.getByField(fieldId);
    if (result.isFailure) {
      throw Exception(result.error);
    }
    return result.data!;
  }

  Future<void> update(Price price) async {
    await priceService.update(price);
    await loadPrices();
  }

  Future<void> delete(Price i) async {
    await priceService.delete(i.id);
    await loadPrices();
  }
}
