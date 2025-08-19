part of 'login_cubit.dart';

sealed class LoginState {}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {}

final class LoginSuccess extends LoginState {}

final class LoginFaliuer extends LoginState {
  LoginFaliuer({required this.message});
  final String message;
}
