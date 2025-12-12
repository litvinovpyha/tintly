import 'package:equatable/equatable.dart';
import 'package:tintly/features/price/models/price.dart';

abstract class PriceState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PriceInitial extends PriceState {}

class PriceLoading extends PriceState {}

class PriceLoaded extends PriceState {
  final List<Price> price;
  PriceLoaded(this.price);
  @override
  List<Object?> get props => [price];
}

class PriceError extends PriceState {
  final String message;
  PriceError(this.message);
  @override
  List<Object?> get props => [message];
}
