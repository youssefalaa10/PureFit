import 'package:PureFit/Core/local_db/WaterIntakeDb/waterer_db.dart';
import 'package:PureFit/Features/Water/Data/Model/water_model.dart';

class WaterRepo {
  WaterRepo({required this.watererDb});
  final WatererDb watererDb;

  Future<List<WaterIntake>> getHistoryIntakes() async {
    return await watererDb.getAllIntakes();
  }

  Future<int> getTodayIntake() async {
    return await watererDb.getTodayIntake();
  }

  Future<void> inserOrUpdateIntake(int intake) async {
    await watererDb.insertOrUpdateIntake(intake);
  }

  Future<void> updateIntake(int id, int intake) async {
    await watererDb.updateIntake(id, intake);
  }
}
