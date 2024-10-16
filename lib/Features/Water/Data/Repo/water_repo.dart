import 'package:fitpro/Core/local_db/WaterIntakeDb/waterer_db.dart';

class WaterRepo {
  final WatererDb watererDb;

  WaterRepo({required this.watererDb});

  getHistoryIntakes() async {
    return await watererDb.getAllIntakes();
  }

  getTodayIntake() async {
    return await watererDb.getTodayIntake();
  }

  inserOrUpdateIntake(int intake) async {
    await watererDb.insertOrUpdateIntake(intake);
  }
  updateIntake(int id, int intake) async {
    await watererDb.updateIntake(id, intake);
  }

}
