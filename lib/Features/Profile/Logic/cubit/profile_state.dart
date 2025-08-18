part of 'profile_cubit.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {
  ProfileSuccess({required this.user});
  final UserModel user;
}

class ProfileError extends ProfileState {
  ProfileError({required this.message});
  final String message;
}

class ProfileUpdating extends ProfileState {}

class ProfileUpdated extends ProfileState {}
