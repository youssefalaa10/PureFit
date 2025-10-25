import 'package:PureFit/Features/Sleep/Data/Model/sleepmodel.dart';
import 'package:PureFit/Features/Sleep/Data/Reposotiory/sleep_repo.dart';
import 'package:bloc/bloc.dart';

import '../../../../Core/helpers/app_logger.dart';

part 'sleep_state.dart';

class SleepCubit extends Cubit<SleepState> {
  SleepCubit(this.sleepRepo) : super(SleepInitial());
  final SleepRepo sleepRepo;

  Future<void> getallsessions() async {
    try {
      emit(SleepLoading());
      final response = await sleepRepo.getallsessions();
      emit(SleepSuccess(list: response));
    } on Exception catch (e) {
      AppLogger.error(e.toString(), StackTrace.current);
      emit(SleepFailuer());
    }
  }

  Future<void> insertSession(SleepSession sleepsession) async {
    await sleepRepo.insertSleep(sleepsession);
    AppLogger.info('sucess');
  }

  Future<void> deleteSession(SleepSession session) async {
    try {
      if (session.id != null) {
        await sleepRepo.deleteSleepSession(session.id!);
        // Reload sessions after deletion
        await getallsessions();
        AppLogger.info('Sleep session deleted successfully');
      }
    } on Exception catch (e) {
      AppLogger.error('Failed to delete sleep session: $e', StackTrace.current);
      emit(SleepFailuer());
    }
  }
}
