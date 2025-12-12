import 'package:tintly/core/repository/base_repository.dart';
import 'package:tintly/features/price/models/price.dart';
import 'package:tintly/shared/utils/id_generator.dart';

class PriceRepository extends GenericRepository<Price> {
  PriceRepository() : super('price');

  @override
  Future<Price> create(Price item) async {
    final newPrice = Price(
      id: IdGenerator.generate(),
      brand: item.brand,
      field: item.field,
      pricePerUnit: item.pricePerUnit,
      placeholder: item.placeholder,
    );

    await box.put(newPrice.id, newPrice);
    return newPrice;
  }

  Future<List<Price>> getAllByField(field) async {
    final allPrices = box.values.cast<Price>().toList();
    return allPrices.where((price) => price.field.id == field.id).toList();
  }
}
