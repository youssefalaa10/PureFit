import 'package:bloc/bloc.dart';
import 'package:fitpro/Features/Exercises/Data/Model/workout_categories_model.dart';
import 'package:fitpro/Features/Exercises/Data/Repo/workout_categories_repo.dart';

part 'workout_programs_state.dart';

class WorkoutProgramsCubit extends Cubit<WorkoutProgramsState> {
  final WorkoutCategoriesRepo workoutCategoriesRepo;

  WorkoutProgramsCubit(this.workoutCategoriesRepo)
      : super(WorkoutProgramsInitial());

 fetchWorkoutPrograms() async {
    emit(WorkoutProgramsLoading());
    try {
      final workoutPrograms = await workoutCategoriesRepo.getWorkoutCategories();
      if (workoutPrograms != null && workoutPrograms.isNotEmpty) {
        emit(WorkoutProgramsSuccess(workoutPrograms));
      } else {
        emit(WorkoutProgramsError("No workout programs found"));
      }
    } catch (e) {
      emit(WorkoutProgramsError("Failed to load workout programs: $e"));
    }
  }
}
