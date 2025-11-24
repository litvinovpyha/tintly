import 'package:tintly/core/models/base_model.dart';
import 'package:tintly/core/base_repository.dart';
import 'package:tintly/core/result.dart';
import 'package:tintly/shared/utils/id_generator.dart';

abstract class BaseService<T extends BaseModel> {
  final GenericRepository<T> repository;
  BaseService(this.repository);

  Future<Result<T>> create(T item) async {
    try {
      final validation = item.validate();
      if (!validation.isValid) {
        return Failure('Validation failed: ${validation.errors.join(', ')}');
      }

      final result = await repository.create(item);
      return Success(result);
    } catch (e) {
      return Failure('Failed to create item: ${e.toString()}');
    }
  }

  Future<Result<List<T>>> getAll() async {
    try {
      final result = await repository.getAll();
      return Success(result);
    } catch (e) {
      return Failure('Failed to get all items: ${e.toString()}');
    }
  }

  Future<Result<T?>> get(String id) async {
    try {
      final result = await repository.get(id);
      return Success(result);
    } catch (e) {
      return Failure('Failed to get item: ${e.toString()}');
    }
  }

  Future<Result<T?>> update(T item) async {
    try {
      final validation = item.validate();
      if (!validation.isValid) {
        return Failure('Validation failed: ${validation.errors.join(', ')}');
      }

      final result = await repository.update(item);
      return Success(result);
    } catch (e) {
      return Failure('Failed to update item: ${e.toString()}');
    }
  }

  Future<Result<void>> delete(String id) async {
    try {
      await repository.delete(id);
      return const Success(null);
    } catch (e) {
      return Failure('Failed to delete item: ${e.toString()}');
    }
  }

  String generateId() => IdGenerator.generate();
}
