abstract class VerificationState {}

class VerificationInitial extends VerificationState {}

class VerificationLoading extends VerificationState {}

class VerificationSuccess extends VerificationState {
  final String message;

  VerificationSuccess(this.message);
}

class VerificationError extends VerificationState {
  final String error;

  VerificationError(this.error);
}
