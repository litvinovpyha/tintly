import 'package:hive_flutter/hive_flutter.dart';
import 'package:tintly/features/admin/models/calculator_field_with_field.dart';
import 'package:tintly/features/admin/models/calculator_field.dart';
import 'package:tintly/features/admin/models/calculator_session.dart';
import 'package:tintly/features/admin/models/field.dart';
import 'package:tintly/core/services/base_service.dart';
import 'package:tintly/core/result.dart';
import 'package:tintly/features/history/services/before_after_storage_service.dart';
import 'package:image_picker/image_picker.dart';

class CalculatorSessionService extends BaseService<CalculatorSession> {
  CalculatorSessionService(super.repository);
  final _storage = BeforeAfterStorageService();

  @override
  Future<Result<CalculatorSession>> create(CalculatorSession item) async {
    print('Creating session with consumption data: ${item.consumptionData}');
    final session = CalculatorSession(
      id: generateId(),
      userId: item.userId,
      clientId: item.clientId,
      calculatorId: item.calculatorId,
      createdAt: DateTime.now(),
      totalAmount: item.totalAmount,
      consumptionData: item.consumptionData,
      calculatorName: item.calculatorName,
    );
    print('Session created with consumption data: ${session.consumptionData}');
    return super.create(session);
  }

  Future<List<CalculatorFieldWithField>> getFieldsForCalculator(
    String calculatorId,
  ) async {
    final calculatorFieldBox = await Hive.openBox<CalculatorField>(
      'calculatorFields',
    );
    final fieldBox = await Hive.openBox<Field>('fields');

    final calculatorFields =
        calculatorFieldBox.values
            .where((cf) => cf.calculatorId == calculatorId && cf.isActive)
            .toList()
          ..sort((a, b) => a.position.compareTo(b.position));

    final List<CalculatorFieldWithField> validItems = [];

    for (var cf in calculatorFields) {
      final matchingFields = fieldBox.values.where((f) => f.id == cf.fieldId);

      if (matchingFields.isEmpty) {
        await calculatorFieldBox.delete(cf.id);
        continue;
      }

      final field = matchingFields.first;
      validItems.add(
        CalculatorFieldWithField(calculatorField: cf, field: field),
      );
    }

    return validItems;
  }

  Future<List<CalculatorSession>> getToday({String? type}) async {
    final result = await super.getAll();
    if (result.isFailure) return [];

    final sessions = result.data!;
    final now = DateTime.now();

    final todaySessions = sessions.where((s) {
      final date = s.createdAt;
      final isToday =
          date.year == now.year &&
          date.month == now.month &&
          date.day == now.day;
      final matchesType = type == null || type == 'Все'
          ? true
          : (s.calculatorId == type);

      return isToday && matchesType;
    }).toList();
    todaySessions.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return todaySessions;
  }

  Future<List<CalculatorSession>> getConsumptionByPeriod(
    String period, {
    String? type,
  }) async {
    final sessionsResult = await getAll();
    if (sessionsResult.isFailure) return [];

    final sessions = sessionsResult.data!;
    final now = DateTime.now();

    late DateTime startDate;

    switch (period) {
      case 'week':
        startDate = now.subtract(const Duration(days: 7));
        break;
      case 'month':
        startDate = DateTime(now.year, now.month, 1);
        break;
      case '3months':
        startDate = DateTime(now.year, now.month - 3, now.day);
        break;
      case '6months':
        startDate = DateTime(now.year, now.month - 6, now.day);
        break;
      case 'year':
        startDate = DateTime(now.year - 1, now.month, now.day);
        break;
      default:
        startDate = DateTime(now.year, now.month, now.day);
    }

    final filteredSessions = sessions.where((s) {
      final inRange =
          s.createdAt.isAfter(startDate) && s.createdAt.isBefore(now);

      final matchesType = type == null || type == 'Все'
          ? true
          : (s.calculatorId == type);

      return inRange && matchesType;
    }).toList();

    filteredSessions.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return filteredSessions;
  }

  Future<void> updateFieldPositions(
    String calculatorId,
    List<CalculatorFieldWithField> items,
  ) async {
    final calculatorFieldBox = await Hive.openBox<CalculatorField>(
      'calculatorFields',
    );

    for (int i = 0; i < items.length; i++) {
      final cf = items[i].calculatorField.copyWith(position: i);
      await calculatorFieldBox.put(cf.id, cf);
    }
  }

  Future<void> deleteAllSessions() async {
    final box = await Hive.openBox<CalculatorSession>('calculatorSessions');
    await box.clear();
  }

  Future<Result<CalculatorSession?>> addPhoto({
    required CalculatorSession session,
    required bool isBefore,
  }) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked == null) {
      return Failure<CalculatorSession>("Фото не выбрано");
    }

    final savedPath = await _storage.saveLocalImage(
      picked,
      session.id,
      isBefore,
    );

    final updated = session.copyWith(
      beforePhotos: isBefore
          ? [...(session.beforePhotos ?? []), savedPath]
          : session.beforePhotos,
      afterPhotos: !isBefore
          ? [...(session.afterPhotos ?? []), savedPath]
          : session.afterPhotos,
    );

    final result = await super.update(updated);
    return result;
  }
}
