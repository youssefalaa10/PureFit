import 'package:fitpro/Core/local_db/SleepDb/sleepdb.dart';
import 'package:fitpro/Features/Sleep/Data/Model/sleepmodel.dart';

class SleepRepo {
  final SleepDb db;

  SleepRepo({required this.db});

  insertSleep(SleepSession sleepsession) async {
    await db.insertSleepSession(sleepsession);
  }

  getallsessions() async {
    return await getallsessions();
  }
}
