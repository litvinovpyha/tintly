import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:tintly/core/controllers/base_controller.dart';
import 'package:tintly/core/logger/app_logger.dart';
import 'package:tintly/features/admin/models/calculator_session.dart';
import 'package:tintly/features/admin/models/calculator_field_with_field.dart';
import 'package:tintly/features/admin/services/calculator_session_service.dart';

class CalculatorSessionController extends BaseController<CalculatorSession> {
  CalculatorSessionController(super.service);
  CalculatorSessionService get calculatorSessionService =>
      service as CalculatorSessionService;

  Future<List<CalculatorFieldWithField>> getAll(String calculatorId) async {
    return await calculatorSessionService.getFieldsForCalculator(calculatorId);
  }

  Future<CalculatorSession?> getItem(String id) async {
    final result = await service.get(id);

    return result.when(
      success: (data) {
        error = null;
        AppLogger.info('Item $id loaded successfully', runtimeType.toString());
        return data;
      },
      failure: (message) {
        error = message;
        AppLogger.error(
          'Failed to load item $id: $message',
          runtimeType.toString(),
        );
        return null;
      },
    );
  }

  Future<List<CalculatorSession>> getToday(String type) async {
    return await calculatorSessionService.getToday(type: type);
  }

  Future<List<CalculatorSession>> getConsumptionByPeriod(
    String period,
    String type,
  ) async {
    return await calculatorSessionService.getConsumptionByPeriod(
      period,
      type: type,
    );
  }

  Future<void> deleteAllSessions() async {
    await calculatorSessionService.deleteAllSessions();
    await loadItems();
  }

  Future<List<CalculatorSession>> getSessionsByClientId(String clientId) async {
    if (items.isEmpty) {
      await loadItems();
    }

    final sessions = items.where((s) {
      return s.clientId == clientId;
    }).toList();

    return sessions;
  }

  Future<CalculatorSession?> addPhoto(
    CalculatorSession session,
    bool isBefore,
    File file,
  ) async {
    // Сохраняем файл локально, например в documentsDirectory
    final dir = await getApplicationDocumentsDirectory();
    final newPath = '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
    final newFile = await file.copy(newPath);

    if (isBefore) {
      session.beforePhotos = [...?session.beforePhotos, newFile.path];
    } else {
      session.afterPhotos = [...?session.afterPhotos, newFile.path];
    }

    await update(session); // обновляем сессию в базе
    return session;
  }
}
