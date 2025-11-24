abstract class BaseModel {
  String? get id;

  /// Проверяет валидность модели
  bool get isValid => validationErrors.isEmpty;

  /// Возвращает список ошибок валидации
  List<String> get validationErrors;

  /// Валидирует модель и возвращает результат
  ValidationResult validate() {
    final errors = validationErrors;
    return ValidationResult(isValid: errors.isEmpty, errors: errors);
  }
}

class ValidationResult {
  final bool isValid;
  final List<String> errors;

  const ValidationResult({required this.isValid, required this.errors});

  @override
  String toString() => 'ValidationResult(isValid: $isValid, errors: $errors)';
}
