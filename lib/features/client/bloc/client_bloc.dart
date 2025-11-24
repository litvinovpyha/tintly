// calculator_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tintly/features/client/bloc/client_event.dart';
import 'package:tintly/features/client/bloc/client_state.dart';
import 'package:tintly/features/client/models/client.dart';
import 'package:tintly/features/client/repositories/client_repository.dart';

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

    on<DeleteClient>((event, emit) async {
      try {
        await r.delete(event.id);
        _allClients.removeWhere((c) => c.id == event.id);
        emit(ClientLoaded(_allClients));
      } catch (e) {
        emit(ClientError(e.toString()));
      }
    });

    on<CreateClientRequested>((event, emit) async {
      try {
        final client = Client(name: event.name, id: '');
        final newClient = await r.create(client);
        _allClients.add(newClient);
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
