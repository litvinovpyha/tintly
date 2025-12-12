import 'package:tintly/features/user/models/user.dart';

abstract class UserEvent {}

class LoadUser extends UserEvent {}

class AddUser extends UserEvent {
  final User user;
  AddUser(this.user);
}

class UpdateUser extends UserEvent {
  final User user;
  UpdateUser(this.user);
}

class DeleteUser extends UserEvent {
  final String id;
  DeleteUser(this.id);
}

class ChangeRole extends UserEvent {
  final String role;
  ChangeRole(this.role);
}
