import 'package:tintly/core/init/hive_initializer.dart';
import 'package:tintly/core/init/service_locator_initializer.dart';

class AppInitializer {
  static Future<void> init() async {
    try {
      await HiveInitializer.init();
      ServiceLocatorInitializer.init();
    } catch (e) {
      throw Exception('Failed to initialize app: $e');
    }
  }
}
