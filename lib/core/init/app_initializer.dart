import 'package:firebase_core/firebase_core.dart';
import 'package:tintly/core/auth/bloc/auth_bloc.dart';
import 'package:tintly/core/auth/bloc/auth_event.dart';
import 'package:tintly/core/auth/repository/auth_repository.dart';
import 'package:tintly/core/init/hive_initializer.dart';
import 'package:tintly/firebase_options.dart';

class AppInitializer {
  static Future<AuthBloc> init() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      final AuthRepository authRepository = await HiveInitializer.init();

      final AuthBloc authBloc = AuthBloc(authRepository);

      authBloc.add(AppStarted());

      return authBloc;
    } catch (e) {
      throw Exception('Failed to initialize app: $e');
    }
  }
}
