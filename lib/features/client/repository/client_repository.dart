import 'package:tintly/core/repository/base_repository.dart';
import 'package:tintly/features/client/models/client.dart';
import 'package:tintly/shared/utils/id_generator.dart';

class ClientRepository extends GenericRepository<Client> {
  ClientRepository() : super('client');

  // @override
  // Future<Client> create(Client item) async {
  //   final newClient = Client(id: IdGenerator.generate(), name: item.name);
  //   await box.put(newClient.id, newClient);
  //   return newClient;
  // }

  Future<Client> createClientByName(String name) async {
    final newClient = Client(id: IdGenerator.generate(), name: name);
    await box.put(newClient.id, newClient);
    return newClient;
  }
}
