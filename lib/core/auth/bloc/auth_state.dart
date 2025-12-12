import 'package:equatable/equatable.dart';
import 'package:tintly/features/user/models/user.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class Unauthenticated extends AuthState {
  final String message;
  Unauthenticated(this.message);
  @override
  List<Object?> get props => [message];
}

class Authenticated extends AuthState {
  final User user;
  Authenticated({required this.user});
}

class AuthenticationLoading extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);

  @override
  List<Object?> get props => [message];
}
