import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Data/Model/exercise_model.dart';
import '../../Data/Repo/exercise_repo.dart';

part 'exercise_state.dart';

class ExerciseCubit extends Cubit<ExerciseState> {
  final ExerciseRepo exerciseRepo;

  ExerciseCubit(this.exerciseRepo) : super(ExerciseInitial());

  Future<void> fetchExercises(String bodyPart) async {
    emit(ExerciseLoading());
    try {
      final exercises = await exerciseRepo.getExercises(bodyPart);
      if (exercises != null && exercises.isNotEmpty) {
        emit(ExerciseLoaded(exercises));
      } else {
        emit(ExerciseError("No exercises found for $bodyPart"));
      }
    } catch (e) {
      emit(ExerciseError("Failed to load exercises: $e"));
    }
  }
}
