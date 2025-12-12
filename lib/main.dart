import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tintly/app/main_screen.dart';
import 'package:tintly/core/auth/bloc/auth_bloc.dart';
import 'package:tintly/core/auth/bloc/auth_state.dart';
import 'package:tintly/core/auth/views/login_screen.dart';
import 'package:tintly/core/init/app_initializer.dart';
import 'package:tintly/core/routes/app_routes.dart';
import 'package:tintly/shared/designs/app_color.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final AuthBloc authBloc = await AppInitializer.init();

  runApp(TinTly(authBloc: authBloc));
}

class TinTly extends StatelessWidget {
  final AuthBloc authBloc;

  const TinTly({super.key, required this.authBloc});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (_) => authBloc,
      child: MaterialApp(
        title: 'TinTly',
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en'), Locale('ru')],
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColor.primaryColor,
            surfaceTint: Colors.transparent,
          ),
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
          ),
        ),
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is Authenticated) {
              return MainScreen();
            } else if (state is AuthenticationLoading) {
              return const Scaffold(
                body: Center(
                  child: CupertinoActivityIndicator(
                    radius: 20.0,
                    color: CupertinoColors.activeBlue,
                  ),
                ),
              );
            } else {
              return LoginScreen();
            }
          },
        ),
        routes: AppRoutes.routes,
      ),
    );
  }
}
