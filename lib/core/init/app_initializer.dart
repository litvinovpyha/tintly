import 'package:tintly/core/auth/bloc/auth_bloc.dart';
import 'package:tintly/core/auth/bloc/auth_event.dart';
import 'package:tintly/core/auth/repository/auth_repository.dart';
import 'package:tintly/core/init/hive_initializer.dart';

class AppInitializer {
  // 🎯 Теперь функция возвращает готовый AuthBloc
  static Future<AuthBloc> init() async {
    try {
      // 1. Получаем готовый AuthRepository
      final AuthRepository authRepository = await HiveInitializer.init();

      // 2. Создаем AuthBloc, передавая ему репозиторий
      final AuthBloc authBloc = AuthBloc(authRepository);

      // 3. 🧠 Немедленно запускаем проверку статуса
      authBloc.add(AppStarted());

      // 4. Возвращаем AuthBloc для использования в Flutter-виджетах (main.dart)
      return authBloc;
    } catch (e) {
      // Это очень хорошее место для логирования критических ошибок
      print('Initialization Error: $e');
      throw Exception('Failed to initialize app: $e');
    }
  }
}
