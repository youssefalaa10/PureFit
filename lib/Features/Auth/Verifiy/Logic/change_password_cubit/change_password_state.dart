abstract class ChangePasswordState {}

class ChangePasswordInitial extends ChangePasswordState {}

class ChangePasswordLoading extends ChangePasswordState {}

class ChangePasswordSuccess extends ChangePasswordState {

}

class ChangePasswordError extends ChangePasswordState {
  final String error;

  ChangePasswordError(this.error);
}
