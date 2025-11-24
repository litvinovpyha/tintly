import 'package:tintly/features/products/models/price.dart';
import 'package:tintly/core/services/base_service.dart';
import 'package:tintly/core/result.dart';

class PriceService extends BaseService<Price> {
  PriceService(super.repository);

  @override
  Future<Result<Price>> create(Price item) async {
    final price = Price(
      id: generateId(),
      brand: item.brand,
      field: item.field,
      pricePerUnit: item.pricePerUnit,
      placeholder: item.placeholder,
    );
    return super.create(price);
  }

  Future<Result<List<Price>>> getByField(String fieldId) async {
    final pricesResult = await getAll();
    if (pricesResult.isFailure) {
      return Failure(pricesResult.error!);
    }

    final prices = pricesResult.data!;
    final filtered = prices.where((p) => p.field.id == fieldId).toList();
    return Success(filtered);
  }
}
