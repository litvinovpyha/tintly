import 'package:hive/hive.dart';
import '../../../core/models/base_model.dart';

part 'calculator_session.g.dart';

@HiveType(typeId: 2)
class CalculatorSession extends BaseModel {
  @HiveField(0)
  @override
  final String id;
  @HiveField(1)
  final String userId;
  @HiveField(2)
  final String clientId;
  @HiveField(3)
  final String calculatorId;
  @HiveField(4)
  final DateTime createdAt;
  @HiveField(5)
  final double totalAmount;
  @HiveField(6)
  final Map<String, double>? consumptionData;
  @HiveField(7)
  final String? calculatorName;
  @HiveField(8)
  List<String>? beforePhotos; // убираем final
  @HiveField(9)
  List<String>? afterPhotos; // убираем final

  CalculatorSession({
    required this.id,
    required this.userId,
    required this.clientId,
    required this.calculatorId,
    required this.createdAt,
    required this.totalAmount,
    this.consumptionData,
    this.calculatorName,
    this.beforePhotos,
    this.afterPhotos,
  });
  CalculatorSession copyWith({
    String? id,
    String? userId,
    String? clientId,
    String? calculatorId,
    DateTime? createdAt,
    double? totalAmount,
    Map<String, double>? consumptionData,
    String? calculatorName,
    List<String>? beforePhotos,
    List<String>? afterPhotos,
  }) {
    return CalculatorSession(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      clientId: clientId ?? this.clientId,
      calculatorId: calculatorId ?? this.calculatorId,
      createdAt: createdAt ?? this.createdAt,
      totalAmount: totalAmount ?? this.totalAmount,
      consumptionData: consumptionData ?? this.consumptionData,
      calculatorName: calculatorName ?? this.calculatorName,
      beforePhotos: beforePhotos ?? this.beforePhotos,
      afterPhotos: afterPhotos ?? this.afterPhotos,
    );
  }

  @override
  List<String> get validationErrors {
    final errors = <String>[];
    if (id.isEmpty) errors.add('ID is required');
    if (userId.isEmpty) errors.add('User ID is required');
    if (clientId.isEmpty) errors.add('Client ID is required');
    if (calculatorId.isEmpty) errors.add('Calculator ID is required');
    if (totalAmount < 0) errors.add('Total amount must be non-negative');
    return errors;
  }
}
