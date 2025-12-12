import 'package:equatable/equatable.dart';
import 'package:tintly/features/brand/models/brand.dart';

abstract class BrandState extends Equatable {
  @override
  List<Object?> get props => [];
}

class BrandInitial extends BrandState {}

class BrandLoading extends BrandState {}

class BrandLoaded extends BrandState {
  final List<Brand> brands;
  BrandLoaded(this.brands);
  @override
  List<Object?> get props => [brands];
}

class BrandError extends BrandState {
  final String message;
  BrandError(this.message);
  @override
  List<Object?> get props => [message];
}
