import 'package:tintly/features/history/models/consumption.dart';
import 'package:tintly/core/services/base_service.dart';
import 'package:tintly/core/result.dart';

class ConsumptionService extends BaseService<Consumption> {
  ConsumptionService(super.repository);

  @override
  Future<Result<Consumption>> create(Consumption item) async {
    final consumption = Consumption(
      id: generateId(),
      productName: item.productName,
      unit: item.unit,
      quantity: item.quantity,
    );
    return super.create(consumption);
  }

  Future<Result<Consumption>> addOrUpdate(Consumption item) async {
    final allResult = await getAll();
    if (allResult.isFailure) {
      return Failure(allResult.error!);
    }

    final all = allResult.data!;
    Consumption? existing;
    for (final c in all) {
      if (c.productName == item.productName && c.unit == item.unit) {
        existing = c;
        break;
      }
    }

    if (existing != null) {
      final updated = Consumption(
        id: existing.id,
        productName: existing.productName,
        unit: existing.unit,
        quantity: existing.quantity + item.quantity,
      );
      final updateResult = await update(updated);
      if (updateResult.isFailure) {
        return Failure(updateResult.error!);
      }
      return Success(updateResult.data!);
    } else {
      return await create(item);
    }
  }
}
