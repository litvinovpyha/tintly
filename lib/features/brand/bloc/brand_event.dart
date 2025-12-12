import 'package:tintly/features/brand/models/brand.dart';

abstract class BrandEvent {}

class LoadBrands extends BrandEvent {}

class AddBrand extends BrandEvent {
  final Brand brand;
  AddBrand(this.brand);
}

class UpdateBrand extends BrandEvent {
  final Brand brand;
  UpdateBrand(this.brand);
}
class UpdateBrandByName extends BrandEvent {
  final String newName;
  final String id;
  UpdateBrandByName(this.id,this.newName);
}


class DeleteBrand extends BrandEvent {
  final String id;
  DeleteBrand(this.id);
}

class CreateBrandByName extends BrandEvent {
  final String name;
  CreateBrandByName(this.name);
}
