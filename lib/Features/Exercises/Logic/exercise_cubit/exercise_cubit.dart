import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Data/Model/exercise_model.dart';
import '../../Data/Repo/exercise_repo.dart';

part 'exercise_state.dart';

class ExerciseCubit extends Cubit<ExerciseState> {
  final ExerciseRepo exerciseRepo;
  ExerciseCubit(this.exerciseRepo) : super(ExerciseInitial());
  List<ExerciseModel>? passExercises ;

  Future<void> fetchExercises(String categoryId) async {
    emit(ExerciseLoading());
    try {
      final exercises = await exerciseRepo.getExercises(categoryId);
      if (exercises != null && exercises.isNotEmpty) {
        emit(ExerciseLoaded(exercises));
        passExercises = exercises;
      } else {
        emit(ExerciseError("No exercises found for $categoryId"));
      }
    } catch (e) {
      emit(ExerciseError("Failed to load exercises: $e"));
    }
  }
}