
abstract class CalculatingEvent {}

class LoadCalculatings extends CalculatingEvent {}

class UpdateTotal extends CalculatingEvent {
  final double price;

  UpdateTotal(this.price);
}
