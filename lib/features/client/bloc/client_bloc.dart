import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tintly/features/client/models/client.dart';
import 'package:tintly/features/client/bloc/client_event.dart';
import 'package:tintly/features/client/bloc/client_state.dart';
import 'package:tintly/features/client/repository/client_repository.dart';

class ClientBloc extends Bloc<ClientEvent, ClientState> {
  final ClientRepository r;
  List<Client> _allClients = [];

  ClientBloc(this.r) : super(ClientInitial()) {
    on<LoadClients>((event, emit) async {
      emit(ClientLoading());
      try {
        _allClients = await r.getAll();
        emit(ClientLoaded(_allClients));
      } catch (e) {
        emit(ClientError(e.toString()));
      }
    });
    on<LoadClient>((event, emit) async {
      emit(ClientLoading());
      try {
        final client = await r.get(event.clientId);

        if (client != null) emit(ClientItemLoaded(client));
      } catch (e) {
        emit(ClientError(e.toString()));
      }
    });

    on<AddClient>((event, emit) async {
      try {
        final newClient = await r.create(event.client);
        _allClients.add(newClient);
        emit(ClientLoaded(_allClients));
      } catch (e) {
        emit(ClientError(e.toString()));
      }
    });
    on<UpdateClient>((event, emit) async {
      if (state is ClientItemLoaded) {
        final currentState = state as ClientItemLoaded;

        final updatedClient = currentState.client.copyWith(
          id: event.id,
          name: event.name,
          photo: event.photo,
          phone: event.phone,
          birthday: event.birthday,
          comment: event.comment,
          coloringTechnique: event.coloringTechnique,
          haircutType: event.haircutType,
          serviceDuration: event.serviceDuration,
          whatsapp: event.whatsapp,
          instagram: event.instagram,
          telegram: event.telegram,
        );
        try {
          await r.update(updatedClient);
          emit(ClientItemLoaded(updatedClient));
        } catch (e) {
          emit(ClientError(e.toString()));
        }
      }
    });

    on<UpdateClientList>((event, emit) async {
      try {
        final updated = await r.update(event.client);
        if (updated != null) {
          final index = _allClients.indexWhere((c) => c.id == updated.id);
          if (index != -1) _allClients[index] = updated;
          emit(ClientLoaded(_allClients));
        }
      } catch (e) {
        emit(ClientError(e.toString()));
      }
    });

    on<UpdateClientName>((event, emit) async {
      try {
        final updatedClient = event.client.copyWith(name: event.newName);

        final savedClient = await r.update(updatedClient);

        if (savedClient != null) emit(ClientItemLoaded(savedClient));
      } catch (e) {
        emit(ClientError(e.toString()));
      }
    });

    on<DeleteClient>((event, emit) async {
      try {
        await r.delete(event.id);
        emit(ClientDeleted());
      } catch (e) {
        emit(ClientError(e.toString()));
      }
    });

    on<CreateClientByName>((event, emit) async {
      try {
        final newClient = await r.createClientByName(event.name);
        final updatedList = List<Client>.from(_allClients)..add(newClient);

        _allClients = updatedList;

        emit(ClientLoaded(_allClients));
      } catch (e) {
        emit(ClientError(e.toString()));
      }
    });

    on<FilterClients>((event, emit) {
      final query = event.query.toLowerCase();
      final filtered = _allClients
          .where((c) => c.name.toLowerCase().contains(query))
          .toList();
      emit(ClientLoaded(filtered));
    });
  }
}
