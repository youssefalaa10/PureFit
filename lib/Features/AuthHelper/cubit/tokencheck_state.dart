part of 'tokencheck_cubit.dart';

sealed class TokencheckState {}

final class TokencheckInitial extends TokencheckState {}

final class TokencheckSuccessed extends TokencheckState {}

final class TokencheckFaliuer extends TokencheckState {
  TokencheckFaliuer({required this.message});
  final String? message;
}

final class TokencheckLoading extends TokencheckState {}
