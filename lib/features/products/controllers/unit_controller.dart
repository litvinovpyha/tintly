import 'package:tintly/core/controllers/base_controller.dart';
import 'package:tintly/features/products/models/unit.dart';
import 'package:tintly/features/products/services/unit_service.dart';

class UnitController extends BaseController<Unit> {
  UnitController(super.service);

  UnitService get unitService => service as UnitService;
  
  Future<List<Unit>> getAll() async {
    final result = await service.getAll();
    if (result.isFailure) {
      throw Exception(result.error);
    }
    return result.data!;
  }

}
