import 'package:PureFit/Core/Services/voice_service.dart';
import 'package:PureFit/Core/Services/workout_tracking_service.dart';
import 'package:PureFit/Features/Exercises/Data/Model/exercise_model.dart';
import 'package:PureFit/Features/Exercises/UI/components/get_ready_screen.dart';
import 'package:PureFit/Features/Profile/Logic/cubit/profile_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Core/Components/media_query.dart';
import '../../../Core/Routing/Routes.dart';
import '../../../Core/Shared/app_string.dart';
import '../Logic/training_cubit/training_cubit.dart';
import '../Logic/weekly_exercises_cubit/weekly_exercises_cubit.dart';
import 'components/rest_screen.dart';
import 'components/training_screen.dart';

class ExerciseStages extends StatefulWidget {
  const ExerciseStages({required this.exercises, super.key});
  final List<ExerciseModel> exercises;

  @override
  State<ExerciseStages> createState() => _ExerciseStagesState();
}

class _ExerciseStagesState extends State<ExerciseStages> {
  late PageController _pageController;
  late VoiceService _voiceService;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _voiceService = VoiceService();
    _initializeVoice();
    context.read<TrainingCubit>().startExerciseRoutine();
  }

  Future<void> _initializeVoice() async {
    await _voiceService.initialize();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _voiceService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TrainingCubit, TrainingCubitState>(
        builder: (context, state) {
          if (state is TrainingLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TrainingError) {
            return Center(child: Text(state.message));
          } else if (state is TrainingStage) {
            return Column(
              children: [
                // Progress indicator
                _buildProgressIndicator(context, state),
                // Main content
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      if (state.stage == EnumTrainingStage.getReady)
                        GetReadyScreen(
                            exercises: widget.exercises,
                            index: state.currentExerciseIndex),
                      if (state.stage == EnumTrainingStage.start)
                        TrainingScreen(
                            exercises: widget.exercises,
                            index: state.currentExerciseIndex),
                      if (state.stage == EnumTrainingStage.rest)
                        RestScreen(
                            exercises: widget.exercises,
                            index: state.currentExerciseIndex),
                    ],
                  ),
                ),
                // Voice controls
                _buildVoiceControls(context),
              ],
            );
          } else if (state is TrainingCompleted) {
            // Check if user is logged in before showing completion dialog
            final profileCubit = context.read<ProfileCubit>();
            if (profileCubit.state is ProfileSuccess ||
                profileCubit.user != null) {
            return _buildWorkoutCompleteDialog(context);
            } else {
              // User not logged in, show error and redirect to login
              return _buildLoginRequiredDialog(context);
            }
          } else {
            return const Center(child: Text('Unknown state'));
          }
        },
      ),
    );
  }

  Widget _buildProgressIndicator(BuildContext context, TrainingStage state) {
    final theme = Theme.of(context);
    final progress = (state.currentExerciseIndex + 1) / widget.exercises.length;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Exercise ${state.currentExerciseIndex + 1} of ${widget.exercises.length}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${(progress * 100).round()}%',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
          ),
        ],
      ),
    );
  }

  Widget _buildVoiceControls(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(1.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: () async {
              await _voiceService.setEnabled(!_voiceService.isEnabled);
              setState(() {});
            },
            icon: Icon(
              _voiceService.isEnabled ? Icons.volume_up : Icons.volume_off,
              color: _voiceService.isEnabled ? theme.primaryColor : Colors.grey,
            ),
            tooltip: _voiceService.isEnabled ? 'Disable Voice' : 'Enable Voice',
          ),
          IconButton(
            onPressed: () async {
              await _voiceService.speak('Current exercise progress');
            },
            icon: Icon(
              Icons.info_outline,
              color: theme.primaryColor,
            ),
            tooltip: 'Voice Info',
          ),
        ],
      ),
    );
  }

  Widget _buildLoginRequiredDialog(BuildContext context) {
    final theme = Theme.of(context);
    final mq = CustomMQ(context);

    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.8),
      body: Center(
        child: Card(
          margin: EdgeInsets.all(mq.width(5)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(mq.width(4)),
          ),
          child: Padding(
            padding: EdgeInsets.all(mq.width(6)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Warning Icon
                Icon(
                  Icons.warning_rounded,
                  color: Colors.orange,
                  size: mq.width(15),
                ),
                SizedBox(height: mq.height(2)),

                // Title
                Text(
                  'Login Required',
                  style: TextStyle(
                    fontSize: mq.height(3),
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                    fontFamily: AppString.font,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: mq.height(1)),

                // Message
                Text(
                  'Authentication required. Please login with your account to save workout progress and access all features.',
                  style: TextStyle(
                    fontSize: mq.height(1.8),
                    color: theme.textTheme.bodyMedium?.color,
                    fontFamily: AppString.font,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: mq.height(3)),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                        context,
                        Routes.loginScreen,
                      );
                    },
                    icon: Icon(
                      Icons.login,
                      size: mq.height(2.2),
                    ),
                    label: Text(
                      'Go to Login',
                      style: TextStyle(
                        fontSize: mq.height(1.8),
                        fontWeight: FontWeight.bold,
                        fontFamily: AppString.font,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: mq.width(6),
                        vertical: mq.height(1.5),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(mq.width(2.5)),
                      ),
                      elevation: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWorkoutCompleteDialog(BuildContext context) {
    final theme = Theme.of(context);
    final mq = CustomMQ(context);

    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.8),
      body: Center(
        child: Card(
          margin: EdgeInsets.all(mq.width(5)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(mq.width(4)),
          ),
      child: Padding(
            padding: EdgeInsets.all(mq.width(6)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
                // Success Animation
                _buildSuccessAnimation(mq),
                SizedBox(height: mq.height(2)),

                // Title
            Text(
                  AppString.workoutCompleteTitle(context),
                  style: TextStyle(
                    fontSize: mq.height(3),
                fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                    fontFamily: AppString.font,
              ),
              textAlign: TextAlign.center,
            ),
                SizedBox(height: mq.height(1)),

                // Subtitle
            Text(
                  AppString.workoutCompleteSubtitle(context),
                  style: TextStyle(
                    fontSize: mq.height(1.8),
                    color: theme.textTheme.bodyMedium?.color,
                    fontFamily: AppString.font,
                  ),
              textAlign: TextAlign.center,
            ),
                SizedBox(height: mq.height(3)),

                // Workout Stats
                _buildWorkoutStats(context, mq, theme),
                SizedBox(height: mq.height(3)),

                // Action Buttons
                _buildActionButtons(context, mq, theme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessAnimation(CustomMQ mq) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer ring
        Container(
          width: mq.width(25),
          height: mq.width(25),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.green.withValues(alpha: 0.1),
            border: Border.all(
              color: Colors.green.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
        ),
        // Inner ring
        Container(
          width: mq.width(20),
          height: mq.width(20),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.green.withValues(alpha: 0.2),
            border: Border.all(
              color: Colors.green,
              width: 3,
            ),
          ),
        ),
        // Check icon
        Icon(
          Icons.check_rounded,
          color: Colors.green,
          size: mq.width(12),
        ),
      ],
    );
  }

  Widget _buildWorkoutStats(
      BuildContext context, CustomMQ mq, ThemeData theme) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _getCombinedWorkoutStats(context),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final stats = snapshot.data!;
          return Column(
            children: [
              // Stats Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatItem(
                    AppString.exercisesCompleted(context),
                    '${stats['totalExercises'] ?? 0}',
                    Icons.fitness_center,
                    Colors.blue,
                    mq,
                  ),
                  _buildStatItem(
                    AppString.workoutDuration(context),
                    '${stats['totalDuration'] ?? 0} ${AppString.min(context)}',
                    Icons.timer,
                    Colors.orange,
                    mq,
                  ),
                  _buildStatItem(
                    AppString.caloriesBurned(context),
                    '${stats['caloriesBurned'] ?? 0}',
                    Icons.local_fire_department,
                    Colors.red,
                    mq,
                  ),
                ],
              ),
              SizedBox(height: mq.height(2)),

              // Streak Info
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: mq.width(4),
                  vertical: mq.height(1),
                ),
                decoration: BoxDecoration(
                  color: theme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(mq.width(2)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.whatshot,
                      color: theme.primaryColor,
                      size: mq.height(2.5),
                    ),
                    SizedBox(width: mq.width(2)),
                    Text(
                      '${stats['streak'] ?? 0} ${AppString.dayStreak(context)}',
                      style: TextStyle(
                        fontSize: mq.height(1.6),
                        fontWeight: FontWeight.bold,
                        color: theme.primaryColor,
                        fontFamily: AppString.font,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
        return SizedBox(
          height: mq.height(8),
          child: Center(
            child: CircularProgressIndicator(
              color: theme.primaryColor,
              strokeWidth: 2,
            ),
          ),
        );
      },
    );
  }

  Future<Map<String, dynamic>> _getCombinedWorkoutStats(
      BuildContext context) async {
    try {
      // Store cubit references before async operations
      final trainingCubit = context.read<TrainingCubit>();
      final weeklyCubit = context.read<WeeklyExerciseCubit>();

      // Get workout tracking stats
      final trackingStats = await WorkoutTrackingService.getWorkoutStats();

      // Get current workout stats from training cubit
      final currentWorkoutStats = trainingCubit.getWorkoutStats();

      // Try to get calendar stats from weekly exercises cubit
      Map<String, dynamic> calendarStats = {
        'completionRate': 0.0,
        'currentStreak': 0,
        'longestStreak': 0,
      };

      try {
        calendarStats = weeklyCubit.getCompletionStats();
      } catch (e) {
        // WeeklyExerciseCubit not available, use default calendar stats
        if (kDebugMode) {
          print('WeeklyExerciseCubit not available for stats: $e');
        }
      }

      return {
        'totalExercises': currentWorkoutStats['totalExercises'] ?? 0,
        'totalDuration': currentWorkoutStats['totalDuration'] ?? 0,
        'caloriesBurned': currentWorkoutStats['caloriesBurned'] ?? 0,
        'difficulty': currentWorkoutStats['difficulty'] ?? 'Medium',
        'streak': trackingStats['streak'] ?? 0,
        'totalWorkouts': trackingStats['totalWorkouts'] ?? 0,
        'completionRate': calendarStats['completionRate'] ?? 0.0,
        'currentStreak': calendarStats['currentStreak'] ?? 0,
        'longestStreak': calendarStats['longestStreak'] ?? 0,
      };
    } catch (e) {
      // Return default stats if there's an error
      if (kDebugMode) {
        print('Error getting combined workout stats: $e');
      }
      return {
        'totalExercises': widget.exercises.length,
        'totalDuration': 0,
        'caloriesBurned': 0,
        'difficulty': 'Medium',
        'streak': 0,
        'totalWorkouts': 0,
        'completionRate': 0.0,
        'currentStreak': 0,
        'longestStreak': 0,
      };
    }
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
    CustomMQ mq,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: mq.height(3),
        ),
        SizedBox(height: mq.height(0.5)),
        Text(
          value,
          style: TextStyle(
            fontSize: mq.height(1.8),
            fontWeight: FontWeight.bold,
            color: color,
            fontFamily: AppString.font,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: mq.height(1.4),
            color: Colors.grey[600],
            fontFamily: AppString.font,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(
      BuildContext context, CustomMQ mq, ThemeData theme) {
    return Column(
      children: [
        // Primary Action - Update Calendar
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _updateCalendarAndNavigate(context),
            icon: Icon(
              Icons.calendar_today,
              size: mq.height(2.2),
            ),
            label: Text(
              AppString.markAsComplete(context),
              style: TextStyle(
                fontSize: mq.height(1.8),
                fontWeight: FontWeight.bold,
                fontFamily: AppString.font,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.primaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: mq.width(6),
                vertical: mq.height(1.5),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(mq.width(2.5)),
              ),
              elevation: 2,
            ),
          ),
        ),
        SizedBox(height: mq.height(1.5)),

        // Secondary Actions
            Row(
              children: [
                Expanded(
              child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                        context,
                        Routes.weeklyExerciseScreen,
                      );
                    },
                icon: Icon(
                  Icons.history,
                  size: mq.height(2),
                ),
                label: Text(
                  AppString.viewHistory(context),
                  style: TextStyle(
                    fontSize: mq.height(1.6),
                    fontFamily: AppString.font,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: mq.width(4),
                    vertical: mq.height(1.2),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(mq.width(2.5)),
                  ),
                ),
              ),
            ),
            SizedBox(width: mq.width(3)),
                Expanded(
              child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                        context,
                    Routes.homeScreen,
                  );
                },
                icon: Icon(
                  Icons.home,
                  size: mq.height(2),
                ),
                label: Text(
                  AppString.home(context),
                  style: TextStyle(
                    fontSize: mq.height(1.6),
                    fontFamily: AppString.font,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: mq.width(4),
                    vertical: mq.height(1.2),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(mq.width(2.5)),
                  ),
                ),
                  ),
                ),
              ],
            ),
          ],
    );
  }

  Future<void> _updateCalendarAndNavigate(BuildContext context) async {
    try {
      // Get current user profile
      final profileCubit = context.read<ProfileCubit>();
      String? profileId;
      
      // Check if user is properly logged in
      if (profileCubit.state is ProfileSuccess) {
        final user = (profileCubit.state as ProfileSuccess).user;
        profileId = user.userId;
      } else if (profileCubit.user != null) {
        // Use cached user if available
        profileId = profileCubit.user!.userId;
      } else {
        // No valid user found - show error and redirect to login
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Authentication required. Please login to continue.',
                style: TextStyle(fontFamily: AppString.font),
              ),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
          
          // Navigate to login screen
          Navigator.pushReplacementNamed(
            context,
            Routes.loginScreen,
          );
        }
        return;
      }

      // Check if WeeklyExerciseCubit is available
      try {
        final weeklyCubit = context.read<WeeklyExerciseCubit>();
        await weeklyCubit.markTodayAsCompleted(profileId);
      } catch (e) {
        // If WeeklyExerciseCubit is not available, just show success message
        // The workout is still saved in WorkoutTrackingService
        if (kDebugMode) {
          print('WeeklyExerciseCubit not available: $e');
        }
      }

      // Show success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppString.workoutMarkedComplete(context),
              style: TextStyle(
                fontFamily: AppString.font,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );

        // Navigate to weekly exercise screen
        Navigator.pushReplacementNamed(
          context,
          Routes.weeklyExerciseScreen,
        );
      }
    } catch (e) {
      if (context.mounted) {
        // Check if it's an authentication error
        if (e.toString().contains('authentication') || 
            e.toString().contains('token') ||
            e.toString().contains('401') ||
            e.toString().contains('403')) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Authentication failed. Please login again.',
                style: TextStyle(fontFamily: AppString.font),
              ),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
          
          // Navigate to login screen
          Navigator.pushReplacementNamed(
            context,
            Routes.loginScreen,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${AppString.failedToUpdateCalendar(context)} $e',
                style: TextStyle(fontFamily: AppString.font),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}
