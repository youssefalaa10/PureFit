import 'package:fitpro/Core/LocalDB/track_steps_db.dart';
import 'package:fitpro/Features/TrackSteps/Data/Repository/track_steps_repo.dart';
import 'package:fitpro/Features/TrackSteps/Logic/cubit/track_step_cubit.dart';
import 'package:get_it/get_it.dart';

final getIT = GetIt.instance;

Future<void> setUpGit() async {
  getIT.registerLazySingleton<TrackStepsDB>(() => TrackStepsDB());

  // TrackSteps
  getIT.registerLazySingleton<Trackstepsrepo>(
      () => Trackstepsrepo(trackStepsDB: getIT()));
  getIT.registerFactory<TrackStepCubit>(() => TrackStepCubit(getIT()));
}
