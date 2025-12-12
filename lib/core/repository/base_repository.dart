import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/base_model.dart';

abstract class BaseRepository<T> {
  Future<T> create(T item);
  Future<List<T>> getAll();
  Future<T?> get(String id);
  Future<T?> update(T item);
  Future<void> delete(String id);
}

class GenericRepository<T extends BaseModel> extends BaseRepository<T> {
  @protected
  late final Box<T> box;

  GenericRepository(String boxName)
    : box = Hive.isBoxOpen(boxName)
          ? Hive.box<T>(boxName)
          : throw Exception('Box $boxName is not open');

  @override
  Future<T> create(T item) async {
    await box.put(item.id, item);
    return item;
  }

  @override
  Future<T?> get(String id) async {
    try {
      return box.values.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<T>> getAll() async => box.values.toList();

  @override
  Future<T?> update(T item) async {
    if (item.id != null) {
      await box.put(item.id, item);
      return item;
    }
    return null;
  }

  @override
  Future<void> delete(String id) async {
    final key = box.keys.cast<dynamic>().firstWhere(
      (k) => box.get(k)?.id == id,
      orElse: () => null,
    );
    if (key != null) {
      await box.delete(key);
    }
  }
}
