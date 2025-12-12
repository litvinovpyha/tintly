import 'package:tintly/features/brand/models/brand.dart';
import 'package:tintly/features/field/models/field.dart';
import 'package:tintly/features/price/models/price.dart';

abstract class PriceEvent {}

class LoadPrices extends PriceEvent {}

class LoadPricesByField extends PriceEvent {
  final Field field;
  LoadPricesByField({required this.field});
}

class AddPrice extends PriceEvent {
  final Price price;
  AddPrice(this.price);
}

class CreatePrice extends PriceEvent {
  final Brand brand;
  final Field field;
  final double pricePerUnit;
  final String placeholder;
  CreatePrice({
    required this.brand,
    required this.field,
    required this.pricePerUnit,
    required this.placeholder,
  });
}

class UpdatePrice extends PriceEvent {
  final Price price;
  UpdatePrice(this.price);
}

class UpdatePricePerUnit extends PriceEvent {
  final String priceId;
  final String pricePerUnit;
  UpdatePricePerUnit(this.priceId, this.pricePerUnit);
}

class DeletePrice extends PriceEvent {
  final String id;
  DeletePrice(this.id);
}
