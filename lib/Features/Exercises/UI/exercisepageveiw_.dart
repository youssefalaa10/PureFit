import 'package:fitpro/Core/Components/custom_button.dart';
import 'package:fitpro/Features/Exercises/Data/Model/exercise_model.dart';
import 'package:fitpro/Features/Exercises/UI/components/get_ready_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Core/Routing/Routes.dart';
import '../Logic/TrainingCubit/cubit/training_cubit_cubit.dart';
import 'components/rest_screen.dart';
import 'components/training_screen.dart';

class ExerciseStages extends StatefulWidget {
  final List<ExerciseModel> exercises;
  const ExerciseStages({super.key, required this.exercises});

  @override
  State<ExerciseStages> createState() => _ExerciseStagesState();
}

class _ExerciseStagesState extends State<ExerciseStages> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    context.read<TrainingCubitCubit>().startExerciseRoutine();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TrainingCubitCubit, TrainingCubitState>(
        builder: (context, state) {
          if (state is TrainingLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TrainingError) {
            return Center(child: Text(state.message));
          } else if (state is TrainingStage) {
            return PageView(
              controller: _pageController,
              physics:
                  const NeverScrollableScrollPhysics(), // Prevent user swiping manually
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
            );
          } else if (state is TrainingCompleted) {
            return AlertDialog(
              content: const Text("Training completed!"),
              actions: [
                CustomButton(
                  label: "Done",
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, Routes.weeklyExerciseScreen);
                  },
                ),
              ],
            );
          } else {
            return const Center(child: Text('Unknown state'));
          }
        },
      ),
    );
  }
}
