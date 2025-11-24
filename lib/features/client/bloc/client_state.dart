import 'package:equatable/equatable.dart';

import 'package:tintly/features/client/models/client.dart';

abstract class ClientState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ClientInitial extends ClientState {}

class ClientLoading extends ClientState {}

class ClientLoaded extends ClientState {
  final List<Client> items;

  ClientLoaded(this.items);

  @override
  List<Object?> get props => [items];
}

class ClientError extends ClientState {
  final String message;

  ClientError(this.message);

  @override
  List<Object?> get props => [message];
}
