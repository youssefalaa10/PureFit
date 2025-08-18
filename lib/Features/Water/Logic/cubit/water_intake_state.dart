part of 'water_intake_cubit.dart';

sealed class WaterIntakeState {}

final class WaterIntakeInitial extends WaterIntakeState {}

final class WaterIntakeLoading extends WaterIntakeState {}

final class WaterIntakeSuccess extends WaterIntakeState {
  WaterIntakeSuccess(this.intakes, this.totalIntake);
  final List<WaterIntake> intakes;
  final int totalIntake;
}

final class WaterIntakeFailure extends WaterIntakeState {
  WaterIntakeFailure(this.error);
  final String error;
}
