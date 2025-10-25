import 'package:PureFit/Core/local_db/TrakStepDb/track_steps_db.dart';
import 'package:PureFit/Features/TrackSteps/Data/Model/track_steps_model.dart';

class Trackstepsrepo {
  Trackstepsrepo({required TrackStepsDB trackStepsDB})
      : _trackStepsDB = trackStepsDB;
  final TrackStepsDB _trackStepsDB;

  void setinitDb() {
    _trackStepsDB.initDb();
  }

  Future<List<TrackStepsModel>> readHistorySteps() async {
    return await _trackStepsDB.readHistoryTracks();
  }

  Future<TrackStepsModel?> readStepsByDate(String date) async {
    return await _trackStepsDB.readTrackByDate(date);
  }

  Future<void> upsertSteps(int steps, String date) async {
    await _trackStepsDB.upsertTrack(steps, date);
  }

  Future<void> saveLastRecordedDate(String date) async {
    await _trackStepsDB.saveLastRecordedDate(date);
  }

  Future<String?> getLastRecordedDate() async {
    return await _trackStepsDB.getLastRecordedDate();
  }

  Future<void> deleteTrack(int id) async {
    await _trackStepsDB.deleteTrack(id);
  }
}
