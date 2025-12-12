import 'package:equatable/equatable.dart';

abstract class CalculatingState extends Equatable {
  final double total;
  const CalculatingState({this.total = 0.0});
  @override
  List<Object?> get props => [];
}

class CalculatingInitial extends CalculatingState {}

class CalculatingLoading extends CalculatingState {}

class CalculatingLoaded extends CalculatingState {
  @override
  final double total;

  const CalculatingLoaded({required this.total});
  // здесь меняется состояние с total
  @override
  List<Object?> get props => [total];
}

class CalculatingError extends CalculatingState {
  final String message;
  const CalculatingError(this.message);
  @override
  List<Object?> get props => [message];
}
