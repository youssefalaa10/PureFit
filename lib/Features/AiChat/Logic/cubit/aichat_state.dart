part of 'aichat_cubit.dart';

sealed class AichatState {}

final class AichatInitial extends AichatState {}

final class AichatLoading extends AichatState {}

final class AichatLoaded extends AichatState {
  AichatLoaded({required this.message});
  final String message;
}

final class AichatError extends AichatState {
  AichatError({required this.message});
  final String message;
}
