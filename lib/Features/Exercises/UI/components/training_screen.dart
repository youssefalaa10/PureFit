import 'dart:async';

import 'package:fitpro/Core/Components/back_button.dart';
import 'package:fitpro/Core/Shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Core/Components/media_query.dart';
import '../../Data/Model/exercise_model.dart';
import '../../Logic/training_cubit/training_cubit.dart';

class TrainingScreen extends StatefulWidget {
  final int index;
  final List<ExerciseModel> exercises;
  const TrainingScreen(
      {super.key, required this.exercises, required this.index});
  @override
  TrainingScreenState createState() => TrainingScreenState();
}

class TrainingScreenState extends State<TrainingScreen> {
  late CustomMQ mq;
  Timer? countdownTimer;
  int countdownValue = 0;
  bool Paused = false;

  @override
  void initState() {
    super.initState();
    countdownValue = context.read<TrainingCubit>().exerciseDuration;
    Paused = context.read<TrainingCubit>().isPaused;

    startCountdown();
  }

  void startCountdown() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdownValue > 0 && !Paused) {
        if (mounted) {
          // Check if the widget is still mounted
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
    countdownTimer?.cancel(); // Cancel the timer
    super.dispose(); // Call the superclass dispose
  }

  @override
  Widget build(BuildContext context) {
    mq = CustomMQ(context);

    return Scaffold(
      backgroundColor: ColorManager.backGroundColor,
      appBar: AppBar(
        title: Text('Exercises ${widget.index + 1}/${widget.exercises.length}',
            style: const TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const CustomBackButton(),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ExerciseImageSection(
              index: widget.index,
              mq: mq,
              exercises: widget.exercises,
            ),
            SizedBox(height: mq.height(4)),
            TitleSection(
              index: widget.index,
              mq: mq,
              exercises: widget.exercises,
            ),
            SizedBox(height: mq.height(2)),
            TimerSection(mq: mq, countdownValue: countdownValue),
            SizedBox(height: mq.height(2)),
            PausePlayButtonSection(
              mq: mq,
              isPaused: context.read<TrainingCubit>().isPaused,
              onPressed: () {
                final cubit = context.read<TrainingCubit>();
                if (cubit.isPaused) {
                  cubit.resumeRoutine(); // Resume the timer
                } else {
                  cubit.pauseRoutine(); // Pause the timer
                }
                setState(() {
                  Paused = cubit.isPaused;
                  startCountdown();
                });
                // Trigger a rebuild to update the button
              },
            ),
            SizedBox(height: mq.height(4)),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Instractions",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: mq.height(2.2)),
                  ),
                  SizedBox(
                    width: mq.width(1),
                  ),
                  IconButton(
                      onPressed: () {
                        showAdaptiveDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Text(
                                  "Instraction ",
                                  style: TextStyle(fontSize: mq.height(2)),
                                ),
                                actions: [
                                  Text(widget
                                      .exercises[widget.index].instructions[0])
                                ],
                              );
                            });
                      },
                      icon: const Icon(
                        Icons.info_outline,
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ExerciseImageSection extends StatelessWidget {
  final CustomMQ mq;
  final List<ExerciseModel> exercises;
  final int index;
  const ExerciseImageSection(
      {super.key,
      required this.mq,
      required this.exercises,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: mq.height(30),
      child: Image.network(
        exercises[index].gifUrl!,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}

class TitleSection extends StatelessWidget {
  final CustomMQ mq;
  final List<ExerciseModel> exercises;
  final int index;
  const TitleSection(
      {super.key,
      required this.mq,
      required this.exercises,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return Text(
      exercises[index].name,
      style: TextStyle(
        fontSize: mq.height(3),
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }
}

class TimerSection extends StatelessWidget {
  final CustomMQ mq;
  final int countdownValue;

  const TimerSection(
      {super.key, required this.mq, required this.countdownValue});

  @override
  Widget build(BuildContext context) {
    return Text(
      '${(countdownValue ~/ 60).toString().padLeft(2, '0')} : ${(countdownValue % 60).toString().padLeft(2, '0')}',
      style: TextStyle(
        fontSize: mq.height(6),
        fontWeight: FontWeight.bold,
        color: Colors.teal,
      ),
    );
  }
}

class PausePlayButtonSection extends StatelessWidget {
  final CustomMQ mq;
  final bool isPaused;
  final VoidCallback onPressed;

  const PausePlayButtonSection({
    super.key,
    required this.mq,
    required this.isPaused,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: mq.height(6),
      icon: Icon(
        isPaused ? Icons.play_arrow : Icons.pause,
        color: Colors.teal,
      ),
      onPressed: onPressed,
    );
  }
}
