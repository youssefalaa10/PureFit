import 'package:PureFit/Features/TrackSteps/Data/Model/track_steps_model.dart';
import 'package:PureFit/Features/TrackSteps/Data/Repository/track_steps_repo.dart';
import 'package:bloc/bloc.dart';

part 'track_step_state.dart';

class TrackStepCubit extends Cubit<TrackStepState> {
  TrackStepCubit(this.trackstepsrepo) : super(TrackStepInitial());
  Trackstepsrepo trackstepsrepo;

  void initDb() {
    trackstepsrepo.setinitDb();

    emit(TrackStepInitial());
  }

  Future<int> readStepsByDate(String date) async {
    emit(GetTrackStepLoading());
    try {
      final response = await trackstepsrepo.readStepsByDate(date);
      emit(GetTrackStepSucessByDate(trackSteps: response));

      return response!.steps;
    } catch (e) {
      emit(GetTrackStepErrorByDate(message: e.toString()));
      return 0; // Return 0 on error
    }
  }

  Future<List<TrackStepsModel>> readHistorySteps() async {
    emit(GetTrackStepLoadingByDate());
    try {
      final response = await trackstepsrepo.readHistorySteps();
      emit(GetTrackStepSucess(trackSteps: response));
      return response;
    } catch (e) {
      emit(GetTrackStepError(message: e.toString()));
      return [];
    }
  }

  Future<void> upsertSteps(int steps, String date) async {
    emit(InsertTrackStepLoading());
    try {
      await trackstepsrepo.upsertSteps(steps, date);
      emit(InsertTrackStepSucess());
    } catch (e) {
      emit(InsertTrackStepError(message: e.toString()));
    }
  }

  Future<String?> getLastRecordedDate() async {
    emit(GetLastRecordLoading());
    try {
      final response = await trackstepsrepo.getLastRecordedDate();
      emit(GetLastRecordSucess(lastRecordedSteps: response ?? ''));
      return response;
    } catch (e) {
      emit(GetLastRecordError(message: e.toString()));
      return null;
    }
  }

  Future<void> saveLastRecordedDate(String date) async {
    emit(InsertLastRecordLoading());
    try {
      await trackstepsrepo.saveLastRecordedDate(date);
      emit(InsertLastRecordSuccess());
    } catch (e) {
      emit(InsertTrackStepError(message: e.toString()));
    }
  }

  Future<void> deleteTrack(int id) async {
    try {
      await trackstepsrepo.deleteTrack(id);
      // Reload history after deletion
      await readHistorySteps();
    } catch (e) {
      emit(GetTrackStepError(message: e.toString()));
    }
  }
}
