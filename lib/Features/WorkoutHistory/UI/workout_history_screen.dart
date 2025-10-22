import 'package:PureFit/Core/Components/back_button.dart';
import 'package:PureFit/Core/Components/media_query.dart';
import 'package:PureFit/Core/Services/workout_tracking_service.dart';
import 'package:PureFit/Core/Shared/app_string.dart';
import 'package:flutter/material.dart';

class WorkoutHistoryScreen extends StatefulWidget {
  const WorkoutHistoryScreen({super.key});

  @override
  State<WorkoutHistoryScreen> createState() => _WorkoutHistoryScreenState();
}

class _WorkoutHistoryScreenState extends State<WorkoutHistoryScreen> {
  List<WorkoutSession> _workoutHistory = [];
  Map<String, dynamic> _stats = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWorkoutHistory();
  }

  Future<void> _loadWorkoutHistory() async {
    try {
      final history = await WorkoutTrackingService.getWorkoutHistory();
      final stats = await WorkoutTrackingService.getWorkoutStats();

      setState(() {
        _workoutHistory = history;
        _stats = stats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          AppString.workoutHistory(context),
          style: TextStyle(fontFamily: AppString.font),
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: const CustomBackButton(),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _workoutHistory.isEmpty
              ? _buildEmptyState(context, mq)
              : SingleChildScrollView(
                  padding: EdgeInsets.all(mq.width(4)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStatsSection(context, mq, theme),
                      SizedBox(height: mq.height(2)),
                      _buildHistorySection(context, mq, theme),
                    ],
                  ),
                ),
    );
  }

  Widget _buildEmptyState(BuildContext context, CustomMQ mq) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.fitness_center,
            size: 64,
            color: Colors.grey[400],
          ),
          SizedBox(height: mq.height(2)),
          Text(
            AppString.noWorkoutHistory(context),
            style: TextStyle(
              fontSize: mq.width(4),
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(
      BuildContext context, CustomMQ mq, ThemeData theme) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(mq.width(4)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Workout Statistics',
              style: TextStyle(
                fontSize: mq.width(4.5),
                fontWeight: FontWeight.bold,
                fontFamily: AppString.font,
              ),
            ),
            SizedBox(height: mq.height(2)),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    context,
                    mq,
                    theme,
                    Icons.fitness_center,
                    AppString.totalWorkouts(context),
                    '${_stats['totalWorkouts'] ?? 0}',
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    context,
                    mq,
                    theme,
                    Icons.local_fire_department,
                    AppString.totalCalories(context),
                    '${_stats['totalCalories'] ?? 0}',
                  ),
                ),
              ],
            ),
            SizedBox(height: mq.height(1)),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    context,
                    mq,
                    theme,
                    Icons.timer,
                    AppString.averageWorkoutTime(context),
                    '${_stats['averageWorkoutTime'] ?? 0} min',
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    context,
                    mq,
                    theme,
                    Icons.whatshot,
                    AppString.workoutStreak(context),
                    '${_stats['streak'] ?? 0} days',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    CustomMQ mq,
    ThemeData theme,
    IconData icon,
    String label,
    String value,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          color: theme.primaryColor,
          size: mq.width(6),
        ),
        SizedBox(height: mq.height(0.5)),
        Text(
          value,
          style: TextStyle(
            fontSize: mq.width(4),
            fontWeight: FontWeight.bold,
            color: theme.primaryColor,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: mq.width(3),
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildHistorySection(
      BuildContext context, CustomMQ mq, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Workouts',
          style: TextStyle(
            fontSize: mq.width(4.5),
            fontWeight: FontWeight.bold,
            fontFamily: AppString.font,
          ),
        ),
        SizedBox(height: mq.height(1)),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _workoutHistory.length,
          itemBuilder: (context, index) {
            final session = _workoutHistory[index];
            return _buildWorkoutItem(context, mq, theme, session);
          },
        ),
      ],
    );
  }

  Widget _buildWorkoutItem(
    BuildContext context,
    CustomMQ mq,
    ThemeData theme,
    WorkoutSession session,
  ) {
    final duration = Duration(seconds: session.totalDuration);
    final durationText =
        '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';

    return Card(
      margin: EdgeInsets.only(bottom: mq.height(1)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.primaryColor.withOpacity(0.1),
          child: Icon(
            Icons.fitness_center,
            color: theme.primaryColor,
          ),
        ),
        title: Text(
          session.workoutName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: AppString.font,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${session.exercises.length} exercises'),
            Text('$durationText • ${session.caloriesBurned} cal'),
          ],
        ),
        trailing: Text(
          _formatDate(session.startTime),
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: mq.width(3),
          ),
        ),
        onTap: () {
          _showWorkoutDetails(context, session);
        },
      ),
    );
  }

  void _showWorkoutDetails(BuildContext context, WorkoutSession session) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(session.workoutName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                'Duration: ${Duration(seconds: session.totalDuration).inMinutes} minutes'),
            Text('Calories: ${session.caloriesBurned}'),
            Text('Exercises: ${session.exercises.length}'),
            const SizedBox(height: 16),
            const Text('Exercises:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            ...session.exercises.map((exercise) =>
                Text('• ${exercise.exerciseName} (${exercise.duration}s)')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppString.done(context)),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference < 7) {
      return '$difference days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
