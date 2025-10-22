import 'package:PureFit/Features/Exercises/Data/Model/workout_categories_model.dart';
import 'package:PureFit/Features/Exercises/Data/Repo/workout_categories_repo.dart';
import 'package:bloc/bloc.dart';

import '../../../../Core/Networking/Dio/dio_workout_categories_api.dart';
import '../../../../Core/local_db/workout_categories_cache/workout_categories_cache_service.dart';

part 'workout_programs_state.dart';

class WorkoutProgramsCubit extends Cubit<WorkoutProgramsState> {
  // Store the full list

  WorkoutProgramsCubit(this.workoutCategoriesRepo)
      : super(WorkoutProgramsInitial());
  final WorkoutCategoriesRepo workoutCategoriesRepo;
  List<WorkoutCategoriesModel> allWorkoutPrograms = [];

  // Fetch all workout programs
  Future<void> fetchWorkoutPrograms({bool forceRefresh = false}) async {
    emit(WorkoutProgramsLoading());

    try {
      // Try to fetch from network
      final workoutPrograms =
          await workoutCategoriesRepo.getWorkoutCategories();

      if (workoutPrograms != null && workoutPrograms.isNotEmpty) {
        // Cache the categories for offline use
        await WorkoutCategoriesCacheService.cacheWorkoutCategories(
            workoutPrograms);

        allWorkoutPrograms = workoutPrograms; // Save the full list
        if (!isClosed) {
          emit(WorkoutProgramsSuccess(workoutPrograms));
        }
      } else {
        // Try to load from cache if network returned nothing
        final cachedPrograms =
            await WorkoutCategoriesCacheService.getCachedWorkoutCategories();

        if (cachedPrograms != null && cachedPrograms.isNotEmpty) {
          allWorkoutPrograms = cachedPrograms;
          if (!isClosed) {
            emit(WorkoutProgramsSuccess(cachedPrograms, isFromCache: true));
          }
        } else {
          if (!isClosed) {
            emit(WorkoutProgramsError('No workout programs found'));
          }
        }
      }
    } on WorkoutCategoriesApiException catch (e) {
      // Handle connection errors specifically
      if (e.isConnectionError) {
        // Try to load cached categories
        final cachedPrograms =
            await WorkoutCategoriesCacheService.getCachedWorkoutCategories();

        if (cachedPrograms != null && cachedPrograms.isNotEmpty) {
          // Show cached data with connection error notification
          allWorkoutPrograms = cachedPrograms;
          if (!isClosed) {
            emit(WorkoutProgramsConnectionError(
              'You are offline. Showing cached workout programs.',
              cachedPrograms: cachedPrograms,
            ));
          }
        } else {
          // No cached data available
          if (!isClosed) {
            emit(WorkoutProgramsConnectionError(e.message));
          }
        }
      } else {
        // Other API errors
        if (!isClosed) {
          emit(WorkoutProgramsError(e.message));
        }
      }
    } catch (e) {
      // Generic error handling
      final cachedPrograms =
          await WorkoutCategoriesCacheService.getCachedWorkoutCategories();

      if (cachedPrograms != null && cachedPrograms.isNotEmpty) {
        allWorkoutPrograms = cachedPrograms;
        if (!isClosed) {
          emit(WorkoutProgramsConnectionError(
            'Unable to fetch workout programs. Showing cached data.',
            cachedPrograms: cachedPrograms,
          ));
        }
      } else {
        if (!isClosed) {
          emit(WorkoutProgramsError('Failed to load workout programs: $e'));
        }
      }
    }
  }

  Future<void> retryFetch() async {
    await fetchWorkoutPrograms(forceRefresh: true);
  }
}
