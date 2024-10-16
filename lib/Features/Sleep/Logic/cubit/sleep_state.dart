part of 'sleep_cubit.dart';

sealed class SleepState {}

final class SleepInitial extends SleepState {}

final class SleepLoading extends SleepState {}

final class SleepSuccess extends SleepState {}

final class SleepFailuer extends SleepState {}
