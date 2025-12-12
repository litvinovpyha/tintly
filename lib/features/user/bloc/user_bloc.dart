import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tintly/features/user/bloc/user_event.dart';
import 'package:tintly/features/user/bloc/user_state.dart';
import 'package:tintly/features/user/models/user.dart';
import 'package:tintly/features/user/repository/user_repository.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository r;
  late User user;

  UserBloc(this.r) : super(UserInitial()) {
   
    on<AddUser>((event, emit) async {
      try {
        final newUser = await r.create(event.user);
        user = newUser;
        emit(UserLoaded(user));
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });
    on<UpdateUser>((event, emit) async {
      try {
        final updated = await r.update(event.user);
        if (updated != null) {
          user = updated;
          emit(UserLoaded(user));
        }
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });
    on<DeleteUser>((event, emit) async {
      try {
        if (event.id != user.id) {
          await r.delete(event.id);
          emit(UserLoaded(user));
        }
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });
    on<ChangeRole>((event, emit) async {
      try {
        final updatedUser = user.copyWith(role: event.role);
        await r.update(updatedUser);
        emit(UserLoaded(updatedUser));
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });
  }
}
