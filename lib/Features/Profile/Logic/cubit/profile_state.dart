part of 'profile_cubit.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserModel user;
  ProfileLoaded({required this.user});
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError({required this.message});
}

class ProfileUpdating extends ProfileState {}

class ProfileUpdated extends ProfileState {}
