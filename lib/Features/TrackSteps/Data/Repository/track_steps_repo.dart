import 'package:fitpro/Core/local_db/TrakStepDb/track_steps_db.dart';
import 'package:fitpro/Features/TrackSteps/Data/Model/track_steps_model.dart';

class Trackstepsrepo {
  final TrackStepsDB _trackStepsDB;

  Trackstepsrepo({required TrackStepsDB trackStepsDB})
      : _trackStepsDB = trackStepsDB;

  setinitDb() {
    _trackStepsDB.initDb();
  }

  readHistorySteps() async {
    return await _trackStepsDB.readHistoryTracks();
  }

  Future<TrackStepsModel?> readStepsByDate(String date) async {
    return await _trackStepsDB.readTrackByDate(date);
  }

  upsertSteps(int steps, String date) async {
    await _trackStepsDB.upsertTrack(steps, date);
  }

  saveLastRecordedDate(String date) async {
    await _trackStepsDB.saveLastRecordedDate(date);
  }

  getLastRecordedDate() async {
    return await _trackStepsDB.getLastRecordedDate();
  }
}
