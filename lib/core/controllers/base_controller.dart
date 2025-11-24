import 'package:flutter/material.dart';
import 'package:tintly/core/models/base_model.dart';
import 'package:tintly/core/result.dart';
import 'package:tintly/core/services/base_service.dart';
import 'package:tintly/core/logger/app_logger.dart';

abstract class BaseController<T extends BaseModel> extends ChangeNotifier {
  final BaseService<T> service;
  List<T> items = [];
  bool isLoading = false;
  String? error;

  BaseController(this.service);

  Future<Result<T?>> getById(String id) async => await service.get(id);

  Future<void> loadItems() async {
    if (isLoading) return;
    _setLoading(true);
    error = null;
    AppLogger.info('Loading items', runtimeType.toString());

    try {
      final result = await service.getAll();
      result.when(
        success: (data) {
          items = data;
          error = null;
          AppLogger.info(
            'Successfully loaded ${data.length} items',
            runtimeType.toString(),
          );
        },
        failure: (message) {
          error = message;
          items = [];
          AppLogger.error(
            'Failed to load items: $message',
            runtimeType.toString(),
          );
        },
      );
    } catch (e) {
      error = 'Unexpected error: ${e.toString()}';
      items = [];
      AppLogger.error(
        'Unexpected error while loading items',
        runtimeType.toString(),
        e,
      );
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }

  Future<void> create(T item) async {
    if (isLoading) return;
    _setLoading(true);
    error = null;

    AppLogger.info('Creating item', runtimeType.toString());

    try {
      final result = await service.create(item);
      result.when(
        success: (_) async {
          AppLogger.info('Item created successfully', runtimeType.toString());
          _setLoading(false);

          await loadItems();
        },
        failure: (message) {
          error = message;
          AppLogger.error(
            'Failed to create item: $message',
            runtimeType.toString(),
          );
          _setLoading(false);
        },
      );
    } catch (e) {
      error = 'Unexpected error: ${e.toString()}';
      AppLogger.error(
        'Unexpected error while creating item',
        runtimeType.toString(),
        e,
      );
      _setLoading(false);
    }
  }

  Future<void> update(T item) async {
    if (isLoading) return;
    _setLoading(true);
    error = null;

    try {
      final result = await service.update(item);
      result.when(
        success: (_) async {
          _setLoading(false);

          await loadItems();
        },
        failure: (message) {
          error = message;
          _setLoading(false);
        },
      );
    } catch (e) {
      error = 'Unexpected error: ${e.toString()}';
      _setLoading(false);
    }
  }

  Future<void> delete(String id) async {
    if (isLoading) return;
    _setLoading(true);
    error = null;

    try {
      final result = await service.delete(id);
      result.when(
        success: (_) async {
          _setLoading(false);

          await loadItems();
        },

        failure: (message) {
          error = message;
          _setLoading(false);
        },
      );
    } catch (e) {
      error = 'Unexpected error: ${e.toString()}';
      _setLoading(false);
    }
  }
}
