import 'package:tintly/features/history/models/consumption.dart';

abstract class HistoryEvent {}

class LoadHistory extends HistoryEvent {}

class AddHistory extends HistoryEvent {
  final Consumption history;
  AddHistory(this.history);
}

class UpdateHistory extends HistoryEvent {
  final Consumption history;
  UpdateHistory(this.history);
}

class DeleteHistory extends HistoryEvent {
  final String id;
  DeleteHistory(this.id);
}

class ClearAllHistory extends HistoryEvent {}
