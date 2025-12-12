

import 'package:equatable/equatable.dart';
import 'package:tintly/features/unit/models/unit.dart';

abstract class UnitState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UnitInitial extends UnitState {}

class UnitLoading extends UnitState {}

class UnitLoaded extends UnitState {
  final List<Unit> units;

  UnitLoaded(this.units);

  @override
  List<Object?> get props => [units];
}

class UnitError extends UnitState {
  final String message;

  UnitError(this.message);

  @override
  List<Object?> get props => [message];
}
