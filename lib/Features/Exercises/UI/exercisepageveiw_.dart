import 'package:PureFit/Core/Components/custom_button.dart';
import 'package:PureFit/Core/Services/voice_service.dart';
import 'package:PureFit/Features/Exercises/Data/Model/exercise_model.dart';
import 'package:PureFit/Features/Exercises/UI/components/get_ready_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Core/Routing/Routes.dart';
import '../../../Core/Shared/app_string.dart';
import '../Logic/training_cubit/training_cubit.dart';
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
            return _buildWorkoutCompleteDialog(context);
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

  Widget _buildWorkoutCompleteDialog(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              AppString.trainingCompleted(context),
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Great job! You completed your workout!',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    label: 'View History',
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                        context,
                        Routes.weeklyExerciseScreen,
                      );
                    },
                    backgroundColor: theme.primaryColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomButton(
                    label: AppString.done(context),
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                        context,
                        Routes.weeklyExerciseScreen,
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
