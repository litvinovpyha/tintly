import 'package:flutter/material.dart';
import 'package:tintly/features/products/models/brand.dart';
import 'package:tintly/features/products/services/brand_service.dart';

class BrandController extends ChangeNotifier {
  final BrandService brandService;
  List<Brand> items = [];
  bool isLoading = false;

  BrandController(this.brandService);

  Future<void> loadItems() async {
    if (isLoading) return;

    isLoading = true;
    notifyListeners();

    try {
      final result = await brandService.getAll();
      if (result.isFailure) {
        throw Exception(result.error);
      }
      items = result.data!;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> create(Brand brand) async {
    await brandService.create(brand);
    await loadItems();
  }

  Future<void> update(Brand brand) async {
    await brandService.update(brand);
    await loadItems();
  }

  Future<void> delete(String id) async {
    await brandService.delete(id);
    await loadItems();
  }
}
