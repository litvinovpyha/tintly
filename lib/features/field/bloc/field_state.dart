import 'package:equatable/equatable.dart';
import 'package:tintly/features/field/models/field.dart';

abstract class FieldState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FieldInitial extends FieldState {}

class FieldLoading extends FieldState {}

class FieldsLoaded extends FieldState {
  final List<Field> fields;
  FieldsLoaded(this.fields);
  @override
  List<Object?> get props => [fields];
}

class FieldError extends FieldState {
  final String message;
  FieldError(this.message);

  @override
  List<Object?> get props => [message];
}
