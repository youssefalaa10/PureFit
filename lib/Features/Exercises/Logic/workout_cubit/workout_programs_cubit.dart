import 'package:PureFit/Features/Exercises/Data/Model/workout_categories_model.dart';
import 'package:PureFit/Features/Exercises/Data/Repo/workout_categories_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';

part 'workout_programs_state.dart';

class WorkoutProgramsCubit extends Cubit<WorkoutProgramsState> {
  // Store the full list

  WorkoutProgramsCubit(this.workoutCategoriesRepo)
      : super(WorkoutProgramsInitial());
  final WorkoutCategoriesRepo workoutCategoriesRepo;
  List<WorkoutCategoriesModel> allWorkoutPrograms = [];

  // Fetch all workout programs
  Future<void> fetchWorkoutPrograms() async {
    emit(WorkoutProgramsLoading());
    try {
      final workoutPrograms =
          await workoutCategoriesRepo.getWorkoutCategories();
      if (workoutPrograms != null && workoutPrograms.isNotEmpty) {
        allWorkoutPrograms = workoutPrograms; // Save the full list
        if (!isClosed) {
          emit(WorkoutProgramsSuccess(workoutPrograms));
        }
      } else {
        if (!isClosed) {
          emit(WorkoutProgramsError('No workout programs found'));
        }
      }
    } catch (e) {
      if (!isClosed) {
        // Check if it's a connection error
        if (e is DioException && e.type == DioExceptionType.connectionError) {
          emit(WorkoutProgramsConnectionError(
              'Connection failed. Please check your internet connection.'));
        } else {
          emit(WorkoutProgramsError('Failed to load workout programs: $e'));
        }
      }
    }
  }
}
