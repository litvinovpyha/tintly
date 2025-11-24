import 'package:tintly/core/base_repository.dart';
import 'package:tintly/features/client/models/client.dart';
import 'package:tintly/shared/utils/id_generator.dart';

class ClientRepository extends GenericRepository<Client> {
  ClientRepository() : super('clients');

  @override
  Future<Client> create(Client item) async {
    final newClient = item.copyWith(id: IdGenerator.generate());

    await box.put(newClient.id, newClient);
    return newClient;
  }
}
