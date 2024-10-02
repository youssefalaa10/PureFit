import 'package:dio/dio.dart';
import 'package:fitpro/Core/LocalDB/TrakStepDb/track_steps_db.dart';
import 'package:fitpro/Core/Networking/DioAuthApi/dio_auth_api.dart';
import 'package:fitpro/Core/Networking/interceptors/dio_interceptor.dart';
import 'package:fitpro/Features/LoginScreen/Data/Repo/login_repo.dart';
import 'package:fitpro/Features/LoginScreen/Logic/cubit/login_cubit.dart';
import 'package:fitpro/Features/Signup/Data/Repo/signup_repo.dart';
import 'package:fitpro/Features/Signup/Logic/cubit/signup_cubit.dart';
import 'package:fitpro/Features/TrackSteps/Data/Repository/track_steps_repo.dart';
import 'package:fitpro/Features/TrackSteps/Logic/cubit/track_step_cubit.dart';
import 'package:get_it/get_it.dart';

import '../../Features/Profile/Data/Repo/profile_repo.dart';
import '../../Features/Profile/Logic/cubit/profile_cubit.dart';
import '../Networking/DioAuthApi/dio_profile_api.dart';

final getIT = GetIt.instance;

Future<void> setUpGit() async {
  Dio dio = Dio();
  dio.interceptors.add(DioInterceptor());
  getIT.registerLazySingleton<DioAuthApi>(() => DioAuthApi(dio: dio));
  getIT.registerLazySingleton<TrackStepsDB>(() => TrackStepsDB());

  // TrackSteps
  getIT.registerLazySingleton<Trackstepsrepo>(
      () => Trackstepsrepo(trackStepsDB: getIT()));
  getIT.registerFactory<TrackStepCubit>(() => TrackStepCubit(getIT()));

  //Login
  getIT.registerLazySingleton<LoginRepo>(() => LoginRepo(dioAuthApi: getIT()));
  getIT.registerFactory<LoginCubit>(() => LoginCubit(getIT()));

  //Sign up
  getIT
      .registerLazySingleton<SignupRepo>(() => SignupRepo(dioAuthApi: getIT()));
  getIT.registerFactory<SignupCubit>(() => SignupCubit(getIT()));

    // Profile - Adding new dependencies
  getIT.registerLazySingleton<DioProfileApi>(() => DioProfileApi(dio: dio));
  getIT.registerLazySingleton<ProfileRepo>(() => ProfileRepo(dioProfileApi: getIT()));
  getIT.registerFactory<ProfileCubit>(() => ProfileCubit(getIT<ProfileRepo>()));
}
