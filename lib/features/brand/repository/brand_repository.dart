import 'package:tintly/core/repository/base_repository.dart';
import 'package:tintly/features/brand/models/brand.dart';
import 'package:tintly/shared/utils/id_generator.dart';

class BrandRepository extends GenericRepository<Brand> {
  BrandRepository() : super('brand');

  @override
  Future<Brand> create(Brand item) async {
    final newBrand = item.copyWith(
      id: IdGenerator.generate(),
      name: item.name,
      imageUrl: item.imageUrl,
      isActive: item.isActive,
      placeholder: item.placeholder,
    );
    await box.put(newBrand.id, newBrand);
    return newBrand;
  }

  Future<Brand> createByName(String name) async {
    final newBrand = Brand(
      id: IdGenerator.generate(),
      name: name,
      imageUrl: null,
      isActive: true,
      placeholder: name,
    );
    await box.put(newBrand.id, newBrand);
    return newBrand;
  }
}
