import 'package:fitpro/Core/LocalDB/TrackStepsDB.dart';

class Trackstepsrepo {
  final TrackStepsDB _trackStepsDB;

  Trackstepsrepo({required TrackStepsDB trackStepsDB})
      : _trackStepsDB = trackStepsDB;

  readHistorySteps() async {
    return await _trackStepsDB.readHistoryTracks();
  }

  readStepsByDate(String date) async {
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
