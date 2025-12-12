import 'package:tintly/core/repository/base_repository.dart';
import 'package:tintly/features/history/models/consumption.dart';
import 'package:tintly/shared/utils/id_generator.dart';

class HistoryRepository extends GenericRepository<Consumption> {
  HistoryRepository() : super('Consumption');

  @override
  Future<Consumption> create(Consumption item) async {
    final newConsumption = Consumption(
      id: IdGenerator.generate(),
      name: item.name,
      quantity: item.quantity,
      unit: item.unit,
    );
    await box.put(newConsumption.id, newConsumption);
    return newConsumption;
  }

}
