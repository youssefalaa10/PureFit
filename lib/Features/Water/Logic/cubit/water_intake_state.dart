part of 'water_intake_cubit.dart';

sealed class WaterIntakeState {}

final class WaterIntakeInitial extends WaterIntakeState {}

final class WaterIntakeLoading extends WaterIntakeState {}

final class WaterIntakeSuccess extends WaterIntakeState {
  final List<WaterIntake> intakes;
  final int totalIntake;

  WaterIntakeSuccess(this.intakes, this.totalIntake);
}

final class WaterIntakeFailure extends WaterIntakeState {
  final String error;

  WaterIntakeFailure(this.error);
}
