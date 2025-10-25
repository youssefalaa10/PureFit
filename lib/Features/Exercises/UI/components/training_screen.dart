import 'dart:async';

import 'package:PureFit/Core/Components/back_button.dart';
import 'package:PureFit/Core/Shared/app_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Core/Components/media_query.dart';
import '../../Data/Model/exercise_model.dart';
import '../../Logic/training_cubit/training_cubit.dart';

class TrainingScreen extends StatefulWidget {
  const TrainingScreen(
      {required this.exercises, required this.index, super.key});
  final int index;
  final List<ExerciseModel> exercises;
  @override
  TrainingScreenState createState() => TrainingScreenState();
}

class TrainingScreenState extends State<TrainingScreen> {
  late CustomMQ mq;
  Timer? countdownTimer;
  int countdownValue = 0;
  bool paused = false;

  @override
  void initState() {
    super.initState();
    countdownValue = context.read<TrainingCubit>().exerciseDuration;
    paused = context.read<TrainingCubit>().isPaused;

    startCountdown();
  }

  void startCountdown() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdownValue > 0 && !paused) {
        if (mounted) {
          setState(() {
            countdownValue--;
          });
        }
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  void showInstructionsBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      shape: const RoundedRectangleBorder(),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(mq.width(5)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppString.instructions(context),
                style: TextStyle(
                  fontSize: mq.height(2.5),
                  fontWeight: FontWeight.bold,
                  fontFamily: AppString.font,
                ),
              ),
              SizedBox(height: mq.height(1)),
              Text(
                widget.exercises[widget.index].instructions.isNotEmpty
                    ? widget.exercises[widget.index].instructions[0]
                    : 'No instructions available',
                style: TextStyle(
                  fontSize: mq.height(2),
                  fontFamily: AppString.font,
                ),
              ),
              // SizedBox(height: mq.height(3)),
            ],
          ),
        );
      },
    );
  }

  void skipToNextExercise() {
    // Skip the current exercise and move to the next one
    context.read<TrainingCubit>().skipCurrentExercise();
  }

  @override
  Widget build(BuildContext context) {
    mq = CustomMQ(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          '${AppString.exercises(context)} ${widget.index + 1}/${widget.exercises.length}',
          style: TextStyle(
            fontFamily: AppString.font,
            fontWeight: FontWeight.bold,
            fontSize: mq.height(2),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const CustomBackButton(),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: mq.width(4)),
                child: Column(
                  children: [
                    ExerciseImageSection(
                      index: widget.index,
                      mq: mq,
                      exercises: widget.exercises,
                    ),
                    SizedBox(height: mq.height(1)),
                    TitleSection(
                      index: widget.index,
                      mq: mq,
                      exercises: widget.exercises,
                    ),
                    SizedBox(height: mq.height(1)),
                    EquipmentSection(
                      index: widget.index,
                      mq: mq,
                      exercises: widget.exercises,
                    ),
                    SizedBox(height: mq.height(1)),
                    TimerSection(
                        mq: mq, countdownValue: countdownValue, theme: theme),
                    SizedBox(height: mq.height(1)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PausePlayButtonSection(
                          mq: mq,
                          isPaused: context.read<TrainingCubit>().isPaused,
                          onPressed: () {
                            final cubit = context.read<TrainingCubit>();
                            if (cubit.isPaused) {
                              cubit.resumeRoutine();
                            } else {
                              cubit.pauseRoutine();
                            }
                            setState(() {
                              paused = cubit.isPaused;
                              startCountdown();
                            });
                          },
                        ),
                        SizedBox(width: mq.width(1)),
                        InstructionsButton(
                          mq: mq,
                          theme: theme,
                          onPressed: showInstructionsBottomSheet,
                        ),
                      ],
                    ),
                    SizedBox(height: mq.height(1)),
                  ],
                ),
              ),
            ),
          ),
          SkipButtonSection(
            mq: mq,
            onPressed: skipToNextExercise,
          ),
        ],
      ),
    );
  }
}

class ExerciseImageSection extends StatelessWidget {
  const ExerciseImageSection(
      {required this.mq,
      required this.exercises,
      required this.index,
      super.key});
  final CustomMQ mq;
  final List<ExerciseModel> exercises;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(mq.width(4)),
        color: Colors.grey[100],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(mq.width(4)),
        child: Image.network(
          exercises[index].gifUrl!,
          height: mq.height(40),
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: mq.height(40),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.fitness_center,
                    size: mq.height(8),
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: mq.height(2)),
                  Text(
                    'Exercise Animation',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: mq.height(2),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class TitleSection extends StatelessWidget {
  const TitleSection(
      {required this.mq,
      required this.exercises,
      required this.index,
      super.key});
  final CustomMQ mq;
  final List<ExerciseModel> exercises;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Text(
      exercises[index].name,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: AppString.font,
        fontSize: mq.height(2),
        fontWeight: FontWeight.bold,
        height: 1.2,
      ),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class EquipmentSection extends StatelessWidget {
  const EquipmentSection(
      {required this.mq,
      required this.exercises,
      required this.index,
      super.key});
  final CustomMQ mq;
  final List<ExerciseModel> exercises;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: mq.width(4),
        vertical: mq.height(1),
      ),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(mq.width(5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.fitness_center,
            size: mq.height(2),
            color: Colors.grey[600],
          ),
          SizedBox(width: mq.width(1)),
          Text(
            exercises[index].equipment,
            style: TextStyle(
              fontSize: mq.height(1.8),
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class TimerSection extends StatelessWidget {
  const TimerSection({
    required this.mq,
    required this.countdownValue,
    required this.theme,
    super.key,
  });
  final CustomMQ mq;
  final int countdownValue;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: mq.width(6),
        vertical: mq.height(.5),
      ),
      decoration: BoxDecoration(
        color: theme.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(mq.width(4)),
      ),
      child: Column(
        children: [
          Text(
            'TIME',
            style: TextStyle(
              fontSize: mq.height(1.6),
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
              letterSpacing: 2,
            ),
          ),
          SizedBox(height: mq.height(0.5)),
          Text(
            '${(countdownValue ~/ 60).toString().padLeft(2, '0')}:${(countdownValue % 60).toString().padLeft(2, '0')}',
            style: TextStyle(
              fontSize: mq.height(6),
              fontWeight: FontWeight.bold,
              color: theme.primaryColor,
              fontFamily: AppString.font,
              letterSpacing: 4,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class PausePlayButtonSection extends StatelessWidget {
  const PausePlayButtonSection({
    required this.mq,
    required this.isPaused,
    required this.onPressed,
    super.key,
  });
  final CustomMQ mq;
  final bool isPaused;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.primaryColor,
        elevation: 0,
        padding: EdgeInsets.symmetric(
          horizontal: mq.width(4),
          vertical: mq.height(1),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(mq.width(3)),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
            color: theme.scaffoldBackgroundColor,
            size: mq.height(3.5),
          ),
          SizedBox(width: mq.width(2)),
          Text(
            isPaused ? 'Resume' : 'Pause',
            style: TextStyle(
              fontSize: mq.height(2),
              fontFamily: AppString.font,
              color: theme.scaffoldBackgroundColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class InstructionsButton extends StatelessWidget {
  const InstructionsButton({
    required this.mq,
    required this.theme,
    required this.onPressed,
    super.key,
  });
  final CustomMQ mq;
  final ThemeData theme;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        elevation: 0,
        padding: EdgeInsets.symmetric(
          horizontal: mq.width(4),
          vertical: mq.height(1),
        ),
        side: BorderSide(color: theme.primaryColor, width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(mq.width(3)),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.info_outline,
            color: theme.primaryColor,
            size: mq.height(2.5),
          ),
          SizedBox(width: mq.width(2)),
          Text(
            'Guide',
            style: TextStyle(
              fontSize: mq.height(2),
              fontFamily: AppString.font,
              color: theme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class SkipButtonSection extends StatelessWidget {
  const SkipButtonSection({
    required this.mq,
    required this.onPressed,
    super.key,
  });
  final CustomMQ mq;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: mq.width(1)),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.primaryColor,
            elevation: 0,
            padding: EdgeInsets.symmetric(vertical: mq.height(.5)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(mq.width(3)),
            ),
          ),
          child: Text(
            AppString.skip(context),
            style: TextStyle(
              fontSize: mq.height(2.2),
              fontFamily: AppString.font,
              color: theme.scaffoldBackgroundColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
