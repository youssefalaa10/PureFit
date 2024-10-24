import 'package:bloc/bloc.dart';
import 'package:PureFit/Features/Sleep/Data/Model/sleepmodel.dart';
import 'package:PureFit/Features/Sleep/Data/Reposotiory/sleep_repo.dart';

part 'sleep_state.dart';

class SleepCubit extends Cubit<SleepState> {
  final SleepRepo sleepRepo;
  SleepCubit(this.sleepRepo) : super(SleepInitial());

  getallsessions() async {
    try {
      emit(SleepLoading());
      final response = await sleepRepo.getallsessions();
      emit(SleepSuccess(list: response));
    } on Exception catch (e) {
      print(e);
      emit(SleepFailuer());
    }
  }

  insertSession(SleepSession sleepsession) async {
    await sleepRepo.insertSleep(sleepsession);
    print("sucess");
  }
}
