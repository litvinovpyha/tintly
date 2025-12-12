import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tintly/core/auth/bloc/auth_event.dart';
import 'package:tintly/core/auth/bloc/auth_state.dart';
import 'package:tintly/core/auth/repository/auth_repository.dart';
import 'package:tintly/features/user/models/user.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository r;
  AuthBloc(this.r) : super(Unauthenticated('')) {
    on<AppStarted>(_onAppStarted);
    on<RegisterRequested>(_onRegisterRequested);
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<ChangeRoleRequested>(_onChangeRoleRequested);
    // on<AppleSignInRequested>(_onAppleSignInRequested);
    // on<GoogleSignInRequested>(_onGoogleSignInRequested);
  }
  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    emit(AuthenticationLoading());
    try {
      final User? user = await r.getCurrentUser();
      // if (user != null) {
      emit(Authenticated(user: user!));
      // } else {
      // emit(
      //   Unauthenticated(
      //     'Ошибка проверки авторизации  проверьте подклюбчение к интернету ',
      //   ),
      // );
      // }
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(Unauthenticated(e.toString()));
    }
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthenticationLoading());

    try {
      final User? user = await r.register(
        event.name,
        event.email,
        event.phone,
        event.password,
        event.role,
      );
      if (user != null) {
        emit(Authenticated(user: user));
      } else {
        //  добавить этому методу сообщение говорящее об ошибке
        emit(Unauthenticated('ошибка регистрации проверьте введеные данные '));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(Unauthenticated(e.toString()));
    }
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthenticationLoading());
    try {
      final User? user = await r.logIn(event.email, event.password);
      if (user != null) {
        emit(Authenticated(user: user));
      } else {
        //  добавить этому методу сообщение говорящее об ошибке  "неверные данные  валидация где то здесь происходит или в репоситории"
        emit(
          Unauthenticated('Ошибка входа проверьте подключение к интернету.'),
        );
      }
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(Unauthenticated(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthenticationLoading());
    try {
      await r.logOut();
      emit(
        Unauthenticated('Ошибка выхода проверьте ваше подключение к интернету'),
      );
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(Unauthenticated(e.toString()));
    }
  }

  Future<void> _onChangeRoleRequested(
    ChangeRoleRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthenticationLoading());

    try {
      final newUser = await r.changeRole(event.newRole);
      emit(Authenticated(user: newUser));
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(Unauthenticated(e.toString()));
    }
  }
}
