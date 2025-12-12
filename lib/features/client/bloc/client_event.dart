import 'package:tintly/features/client/models/client.dart';

abstract class ClientEvent {}

class LoadClients extends ClientEvent {}

class LoadClient extends ClientEvent {
  final String clientId;
  LoadClient(this.clientId);
}

class AddClient extends ClientEvent {
  final Client client;
  AddClient(this.client);
}

class UpdateClient extends ClientEvent {
  final String? id;
  final String? name;
  final String? photo;
  final String? phone;
  final String? birthday;
  final String? comment;
  final String? coloringTechnique;
  final String? haircutType;
  final String? serviceDuration;
  final String? whatsapp;
  final String? instagram;
  final String? telegram;

  UpdateClient({
    this.id,
    this.name,
    this.photo,
    this.phone,
    this.birthday,
    this.comment,
    this.coloringTechnique,
    this.haircutType,
    this.serviceDuration,
    this.whatsapp,
    this.instagram,
    this.telegram,
  });
}

class UpdateClientList extends ClientEvent {
  final Client client;
  UpdateClientList(this.client);
}

class UpdateClientName extends ClientEvent {
  final Client client;
  final String newName;
  UpdateClientName(this.client, this.newName);
}

class DeleteClient extends ClientEvent {
  final String id;
  DeleteClient(this.id);
}

class CreateClientByName extends ClientEvent {
  final String name;
  CreateClientByName(this.name);
}

class FilterClients extends ClientEvent {
  final String query;
  FilterClients(this.query);
}
