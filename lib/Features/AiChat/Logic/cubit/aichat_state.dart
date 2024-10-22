part of 'aichat_cubit.dart';

sealed class AichatState {}

final class AichatInitial extends AichatState {}

final class AichatLoading extends AichatState {}

final class AichatLoaded extends AichatState {
  final String message;

  AichatLoaded({required this.message});
}

final class AichatError extends AichatState {
  final String message;

  AichatError({required this.message});
}
