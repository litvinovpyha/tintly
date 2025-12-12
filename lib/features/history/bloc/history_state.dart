import 'package:equatable/equatable.dart';
import 'package:tintly/features/history/models/consumption.dart';

abstract class HistoryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<Consumption> consumption;
  HistoryLoaded(this.consumption);

  @override
  List<Object?> get props => [consumption];
}

class HistoryError extends HistoryState {
  final String message;
  HistoryError(this.message);
  
  @override
  List<Object?> get props => [message];
}
