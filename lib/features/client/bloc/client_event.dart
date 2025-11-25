import 'package:tintly/features/client/models/client.dart';

abstract class ClientEvent {}

class LoadClients extends ClientEvent {}

class AddClient extends ClientEvent {
  final Client client;
  AddClient(this.client);
}

class UpdateClient extends ClientEvent {
  final Client client;
  UpdateClient(this.client);
}

class DeleteClient extends ClientEvent {
  final String id;
  DeleteClient(this.id);
}

class CreateClientRequested extends ClientEvent {
  final String name;
  CreateClientRequested(this.name);
}

class FilterClients extends ClientEvent {
  final String query;
  FilterClients(this.query);
}

class LoadClientById extends ClientEvent {
  final String id;
  LoadClientById(this.id);
}
